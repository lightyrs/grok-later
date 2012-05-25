class BookmarkletController < ApplicationController

  before_filter :find_or_create_link, :only => [ :start, :add ]

  def index
    head :ok
  end

  def start   
    head :ok
  end

  def add
    head :ok
  end

  private

  def find_or_create_link
    @link = Link.find_or_create_by_href(params[:url])
  end
end
