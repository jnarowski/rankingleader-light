module Ruseo
  module Yahoo
    # Usage:
    # 
    #   @g = Yahoo::Explorer.inlink_data "www.domain.com"
    #   @g.parse!
    class Explorer
      attr_accessor :result
      
      API_URL = 'http://search.yahooapis.com/SiteExplorerService'
      API_VERSION = 1
      
      def self.inlink_data(query, options = {})    
        options[:query] = Format.url(query, :http => true) 
        options[:appid] = YAHOO_API_KEY
        options[:output] = :json
        @result = get('inlinkData', options)  
        total_results_available
      end

      def self.page_data(query, options = {})    
        options[:query] = Format.url(query, :http => true)  
        options[:appid] = YAHOO_API_KEY
        options[:output] = :json
        @result = get('pageData', options)  
        total_results_available
      end
            
      def self.total_results_available
        raise DataError.new("There was a problem returning data for #{options[:query]}") unless @result['ResultSet'] && @result['ResultSet']['totalResultsAvailable']
        @result['ResultSet']['totalResultsAvailable'].to_i 
      end

      def self.get(method, options) 
        response = Connection.get("#{ API_URL }/V#{ API_VERSION }/#{ method }", options)  
        JSON.parse(response) if response        
      end
      
    end # end Explorer    
  end # end Yahoo
end # end Ruseo