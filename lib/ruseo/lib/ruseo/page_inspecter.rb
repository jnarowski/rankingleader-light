module Ruseo
  class PageInspecter
    attr_accessor :backlinks
    
    def initialize(url, options = {})
      @url = url
      @backlink = Format.url(options[:backlink])
      @backlinks = []
      @page = Page.new(url)
      @page.parse
    end
    
    def find_backlinks(backlink = @backlink)
      raise DataError.new("No backlink URL provided") unless backlink
      @page.doc.css('a').each do |link|
        @backlinks << Link.new(link) if link_matches_backlink?(link, backlink) 
      end
    end
    
    protected
    
    def link_matches_backlink?(link, link_to_find)
      link['href'].include?(link_to_find) if link && link['href']
    end
            
  end
end