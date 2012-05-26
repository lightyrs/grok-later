require 'readability'
require 'sanitize'
require 'open-uri'

class Link < ActiveRecord::Base

  before_save    :set_metadata
  before_create  :set_subjects

  attr_accessor :meta, :doc

  validates :href, :presence => true, :uniqueness => true

  has_many :references, :dependent => :destroy
  has_many :subjects, :through => :references

  def most_eligible_subjects(count=1)
    subject_candidates.first(count)
  end

  def subject_candidates
    TermExtract.extract(subject_samples).sort_by(&:last).
        reverse.map(&:first).reject{|t| t.size <= 2 }
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

  private 

  def set_metadata

    @meta = get_metadata
    @doc = get_extended_metadata

    self.title = @meta.title
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
    self.share_count = shares
    self.body_html = extracted_html
    self.body_text = Sanitize.clean(body_html).squish rescue ''
    self.analyzed_at = DateTime.now
  end

  def set_subjects
    most_eligible_subjects(3).each do |candidate|
      self.subjects << Subject.find_or_create_by_name(candidate) rescue nil
    end
  end

  def subject_samples
    "#{title}. #{description}. #{keywords}. #{og_title}. #{body_text}. #{lede}."
  end
end
