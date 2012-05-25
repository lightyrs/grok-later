class Link < ActiveRecord::Base

  before_save :set_metadata

  attr_accessor :meta

  validates :href, :presence => true, :uniqueness => true

  def href_metadata
    MetaInspector.new(href) rescue nil
  end

  def shares(network="all")
    counts = ShareCounts.send(network.to_sym, href)
    counts.instance_of?(Hash) ? counts.values.compact.inject(:+) : counts rescue 0
  end

  private

  def get_metadata
    href_metadata
  end

  def set_metadata

    @meta = get_metadata

    self.title = @meta.title
    self.links = @meta.absolute_links
    self.description = @meta.description rescue nil
    self.keywords = @meta.meta_keywords rescue nil
    self.image = @meta.image
    self.images = @meta.absolute_images
    self.feed = @meta.feed
    self.og_title = @meta.meta_og_title
    self.og_image = @meta.meta_og_image
    self.share_count = shares
    self.analyzed_at = DateTime.now
  end
end
