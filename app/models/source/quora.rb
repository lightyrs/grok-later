class Source::Quora < Source::Base

  class << self

    def extract_query(href)
      CGI::unescape(href.scan(/.com\/([^\/]*)\//).first.shift)
    end
  end
end