class BookmarkletController < ApplicationController

  before_filter :find_or_create_link

  def start   

  end

  def add

  end

  private

  def find_or_create_link
    @link = Link.find_or_create_by_url params[:url]
  end
end
