require 'readability'
require 'sanitize'
require 'open-uri'

class Link < ActiveRecord::Base

  serialize :keywords

  before_save    :set_metadata
  after_create   :set_subjects

  attr_accessor :meta, :doc

  validates :href, :presence => true, :uniqueness => true

  has_many :references, :dependent => :destroy
  has_many :subjects, :through => :references

  def likely_subject
    "Source::#{domain.camelize}".constantize.extract_query(href)
  rescue NameError
    sorted_candidates.first
  end

  def sorted_candidates
    strings = subject_candidates.sort_by_item_freq
    strings.first(5).sort_by do |string|
      (string.similar(href).to_f + string.similar(title).to_f).ceil
    end.reverse
  rescue
    strings
  end

  def subject_candidates
    logger.debug(terms.inspect.red_on_white)
    logger.debug(phrases.inspect.blue_on_white)
    (terms + phrases).reject { |t| t.to_s.size <= 2 }.
                      reject { |t| t.match(/#{Regexp.quote(domain)} ?/i) }
  end

  def shares(network="all")
    counts = ShareCounts.send(network.to_sym, href)
    counts.instance_of?(Hash) ? counts.values.compact.inject(:+) : counts rescue 0
  end

  def extracted_html
    source = open(href).read
    Readability::Document.new(source).content
  end

  def get_metadata
    MetaInspector.new(href) rescue nil
  end

  def get_extended_metadata
    Pismo::Document.new(href) rescue nil
  end

  def terms
    TermExtract.extract(subject_samples).map do |tp|
      weighted = []
      eval("#{tp.last}.times { |_| weighted.push(tp.first) }")
      weighted
    end.flatten
  end

  def phrases
    extractor.phrases(subject_samples).map do |tpw|
      weighted = []
      eval("#{tpw.second}.times { |_| weighted.push(tpw.first) }")
      weighted    
    end.flatten
  end

  def _domain
    Domainatrix.parse(href).domain
  end

  #private

  def set_metadata

    @meta = get_metadata
    @doc = get_extended_metadata

    self.title = @meta.title
    self.domain = _domain rescue ''
    self.links = @meta.absolute_links
    self.authors = @doc.authors
    self.favicon = @doc.favicon
    self.lede = @doc.lede
    self.description = @meta.description rescue @doc.description rescue ''
    self.keywords = @doc.keywords rescue []
    self.image = @meta.image
    self.images = @meta.absolute_images
    self.feed = @meta.feed
    self.og_title = @meta.meta_og_title
    self.og_image = @meta.meta_og_image
    self.share_count = shares rescue 0
    self.body_html = @doc.html_body rescue @meta.parsed_document rescue ''
    self.body_text = @doc.body rescue ''
    self.analyzed_at = DateTime.now
  end

  def set_subjects
    self.subjects.find_or_create_by_name(likely_subject)
  end

  def subject_samples
    sample = ""
    10.times { sample += "#{title}, " }
    10.times { sample += "#{og_title}, " rescue "" }
    sample += weighted_keywords.join(", ")
    sample += "#{description}, #{lede}"
    sample.squish
  end

  def weighted_keywords
    keywords.map do |kw_ary|
      weighted = []
      eval("#{kw_ary.last}.times { |_| weighted.push(kw_ary.first)}")
      weighted
    end.flatten rescue []
  end

  def extractor
    Phrasie::Extractor.new
  end
end
