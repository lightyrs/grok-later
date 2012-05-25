class Link < ActiveRecord::Base

  before_create :set_metadata

  attr_accessor :meta

  validates :href, :presence => true


  def href_metadata
    MetaInspector.new(href).to_hash rescue nil
  end

  def shares(network="all")
    counts = ShareCounts.send(network.to_sym, href)
    counts.instance_of?(Hash) ? counts.values.compact.inject(:+) : counts rescue 0
  end
  

  private

  def get_metadata
    OpenStruct.new(href_metadata)
  end

  def set_metadata

    return true if persisted? and analyzed_at > 1.week.ago

    @meta = get_metadata

    self.title = @meta.title
    self.links = @meta.absolute_links
    self.description = @meta.meta["name"]["description"] rescue nil
    self.keywords = @meta.meta["name"]["keywords"] rescue nil
    self.image = @meta.image
    self.images = @meta.absolute_images
    self.feed = @meta.feed
    self.og_title = @meta.meta_og_title
    self.og_image = @meta.meta_og_image
    self.share_count = shares
    self.analyzed_at = DateTime.now
  end
end
