class Source::Wikipedia < Source::Base

  class << self

    def extract_query(href)
      CGI::unescape(href.scan(/wiki\/(.*)/).last.pop.humanize)
    end
  end
end