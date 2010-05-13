dir = File.dirname(__FILE__)

# External libraries
#require 'nokogiri'  
require 'uri'
require 'open-uri'
require 'json'
require 'pp'

Dir[dir + "/lib/ruseo/*.rb"].each {|lib| require lib }
Dir[dir + "/lib/ruseo/tools/*.rb"].each {|lib| require lib }

module Ruseo
  VERSION = "0.1.0"
  YAHOO_API_KEY = 'Yc07EX7V34FCiVMyOujCQI.GuOQ_oKM7ocdFvzszQRIetQHrA6XTvGpz8DgB4J0-' 
  
  class Connection    
    # Converts a hash to a query string
    def self.hash_to_query(hash)
      hash.map {|key, value| "#{key}=#{value}"}.join("&")
    end
    
    # Opens the connection
    def self.get(url, options)   
      option_query = hash_to_query(options)
      uri = URI.parse(URI.encode(url))
      uri = "#{uri}?#{option_query}" if option_query
      begin 
        @response_body = open(uri,"User-Agent" => "RuSEO GEM").readlines.join
      rescue OpenURI::HTTPError
        raise ConnectionError.new("Ruseo::Connection - Failed to Connect to #{ uri }")
      end 
    end  
         
  end

  class Parse
    def self.html(html)
      Nokogiri::HTML.parse(html)
    end
  end
  
  class Format
    def self.url(url, options = { :www => true }) 
      if url
        new_url = '' 
        old_url = url.gsub(/http:\/\/|www\./, '')
      
        new_url += 'http://' if options[:http]   
        new_url += 'www.' if options[:www]   
        new_url += old_url
        new_url.chomp('/') unless options[:trailing_slash]
        new_url
      else
        nil
      end
    end
  end
  
end