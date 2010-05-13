module Ruseo
  class Page
    attr_reader :url, :data, :doc
    
    def initialize(url)
      @url = Format.url(URI.escape(url), :http => true)   
      fetch
    end
    
    def fetch
      begin
        @data = open(@url, "User-Agent" => "Demo/0.1").read     
      rescue SocketError
        raise NotFoundError.new("Unable to connect to '#{@url}'. Please ensure URL exists.")
      end
    end
    
    def parse
      @doc = Parse.html(@data)
    end
            
  end
end