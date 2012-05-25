require 'share_counts'

class Link < ActiveRecord::Base

  before_create :set_metadata

  attr_accessor :meta

  validates :href, :presence => true

  def href_metadata
    MetaInspector.new(href).to_hash
  end

  def total_shares(network = "all")
    counts.instance_of? Hash ? counts.values.compact.inject(:+) : counts rescue 0
  end

  private

  def get_metadata
    OpenStruct.new(href_metadata)
  end

  def set_metadata
    @meta = get_metadata

    self.title = @meta.title
    self.links = @meta.absolute_links
    self.description = @meta.meta["name"]["description"]
    self.keywords = @meta.meta["name"]["keywords"]
    self.image = @meta.image
    self.images = @meta.absolute_images
    self.feed = @meta.feed
    self.og_title = @meta.meta_og_title
    self.og_image = @meta.meta_og_image
    self.share_count = total_shares
    self.analyzed_at = DateTime.now
  end
end
