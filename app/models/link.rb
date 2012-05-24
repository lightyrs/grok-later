class Link < ActiveRecord::Base

  attr_accessor :analyzed_at

  def initialize(url)
    @meta = url_meta(url)
  end

  def url
    @meta.url
  end

  def scheme
    @meta.scheme
  end

  def title
    @meta.title
  end

  def links
    @meta.absolute_links
  end

  def description
    @meta.description
  end

  def keywords
    @meta.meta_keywords
  end

  def image
    @meta.image
  end

  def images
    @meta.absolute_images
  end

  def feed
    @meta.feed
  end

  def og_title
    @meta.meta_og_title
  end

  def og_image
    @meta.meta_og_image
  end

  private

  def url_meta(url)
    MetaInspector.new(url).tap do |mi|
      @analyzed_at = DateTime.now
    end
  end
end
