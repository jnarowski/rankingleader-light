module Ruseo
  module Google
    # Usage:
    # 
    #   @g = Google::Scraper.new "link:www.domain.com"
    class Scraper
      attr_reader :results
    
      def initialize(keyphrase, start=0, interval=100)  
        @keyphrase = keyphrase
        @start = start
        @interval = interval
        @page = Page.new("http://www.google.com/search?q=#{@keyphrase}&start=#{@start}&num=#{@start + @interval}")
        @page.parse
      end
    
      # Returns Google Backlinks and Site Saturation
      # @g = Google::Scraper.new('link:www.site.com')
      # @g.page_data
      # OR ----------------------------------------
      # @g = Google::Scraper.new('site:www.site.com')
      # @g.page_data
      def page_data
        results = @page.doc.xpath("/html/body/div[2]/p/b[3]")
        results.text.gsub(',', '').to_i if results
      end       
    end
  
    # Usage:
    # 
    #   @page_rank = Google::PageRank.new "www.domain.com"
    class PageRank
      attr_reader :results, :errors
    
      def initialize(url)
        @url = Format.url(url, :trailing_slash => true)     
      end

      def request_uri  
        "http://toolbarqueries.google.com/search?client=navclient-auto&hl=en&ch=#{cn}&ie=UTF-8&oe=UTF-8&features=Rank&q=info:#{ @url }"
      end
 
      def parse
        # open the page   
        page = Page.new(request_uri)
        # get the rank by REGEXP
        rank = page.data.match(/Rank_1:\d:(\d+)/)
        # return the page rank
        return (rank && rank[1] ? rank[1].to_i : 0)
      end
    
      ###############################################################
      # Crazy stuff that noone should know how to do
      ###############################################################
    
      M=0x100000000 # modulo for unsigned int 32bit(4byte)

      def m1(a,b,c,d)
        (((a+(M-b)+(M-c))%M)^(d%M))%M # mix/power mod
      end

      def i2c(i)
        [i&0xff, i>>8&0xff, i>>16&0xff, i>>24&0xff]
      end

      def c2i(s,k=0)
        ((s[k+3].to_i*0x100+s[k+2].to_i)*0x100+s[k+1].to_i)*0x100+s[k].to_i
      end

      def mix(a,b,c)
        a = a%M; b = b%M; c = c%M
        a = m1(a,b,c, c >> 13); b = m1(b,c,a, a <<  8); c = m1(c,a,b, b >> 13)
        a = m1(a,b,c, c >> 12); b = m1(b,c,a, a << 16); c = m1(c,a,b, b >>  5)
        a = m1(a,b,c, c >>  3); b = m1(b,c,a, a << 10); c = m1(c,a,b, b >> 15)
        [a, b, c]
      end

      def old_cn(iurl = 'info:' + @url)
        a = 0x9E3779B9; b = 0x9E3779B9; c = 0xE6359A60
        len = iurl.size 
        k = 0
        while (len >= k + 12) do
          a += c2i(iurl,k); b += c2i(iurl,k+4); c += c2i(iurl,k+8)
          a, b, c = mix(a, b, c)
          k = k + 12
        end
        a += c2i(iurl,k); b += c2i(iurl,k+4); c += (c2i(iurl,k+8) << 8) + len
        a,b,c = mix(a,b,c)
        return c
      end

      def cn
        ch = old_cn
        ch = ((ch/7) << 2) | ((ch-(ch/13).floor*13)&7)
        new_url = []
        20.times { i2c(ch).each { |i| new_url << i }; ch -= 9 }
        ('6' + old_cn(new_url).to_s).to_i
      end
  
      private :m1, :i2c, :c2i, :mix, :old_cn
      attr_accessor :uri
    end
  end
end