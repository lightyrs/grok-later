class BookmarkletController < ApplicationController

  before_filter :find_or_create_link, :only => [ :start, :add ]

  def index

  end

  def start   

  end

  def add

  end

  private

  def find_or_create_link
    @link = Link.find_by_href params[:url]
  end
end
