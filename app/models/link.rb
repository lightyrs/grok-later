require 'readability'
require 'sanitize'
require 'open-uri'

class Link < ActiveRecord::Base

  before_save    :set_metadata
  after_create   :set_subjects

  attr_accessor :meta, :doc

  validates :href, :presence => true, :uniqueness => true

  has_many :references, :dependent => :destroy
  has_many :subjects, :through => :references

  def sorted_candidates
    subject_candidates.sort_by_item_freq
  end

  def subject_candidates
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
    TermExtract.extract(subject_samples).map do |term_point|
      weighted = []
      eval("#{term_point.last}.times { |_| weighted.push(term_point.first) }")
      weighted
    end.flatten
  end

  def phrases
    extractor.phrases(subject_samples).map do |term_point_wcount|
      weighted = []
      eval("#{term_point_wcount.second}.times { |_| weighted.push(term_point_wcount.first) }")
      weighted    
    end.flatten
  end

  private

  def set_metadata

    @meta = get_metadata
    @doc = get_extended_metadata

    self.title = @meta.title
    self.domain = Domainatrix.parse(href).domain rescue ''
    self.links = @meta.absolute_links
    self.authors = @doc.authors
    self.favicon = @doc.favicon
    self.lede = @doc.lede
    self.description = @meta.description rescue ''
    self.keywords = @meta.meta_keywords + @doc.keywords rescue @doc.keywords rescue []
    self.image = @meta.image
    self.images = @meta.absolute_images
    self.feed = @meta.feed
    self.og_title = @meta.meta_og_title
    self.og_image = @meta.meta_og_image
    self.share_count = shares rescue 0
    self.body_html = @meta.parsed_document rescue extracted_html rescue ''
    self.body_text = Sanitize.clean(body_html.text).squish rescue ''
    self.analyzed_at = DateTime.now
  end

  def set_subjects
    self.subjects.find_or_create_by_name(sorted_candidates.first)
  end

  def subject_samples
    <<-eos
      #{title}   #{title}   #{title}   #{title}   #{title}
      #{description}   #{description}   #{description}
      #{og_title}   #{og_title}   #{og_title}
      #{keywords}   #{keywords}
      #{lede}   #{lede}
    eos
  end

  def extractor
    Phrasie::Extractor.new
  end
end
