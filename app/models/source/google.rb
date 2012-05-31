class Source::Google < Source::Base

  class << self

    def extract_query(href)
      CGI::unescape(href.scan(/&q=([^&]+)/).last.pop)
    end
  end
end