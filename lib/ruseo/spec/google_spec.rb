require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

module Ruseo
  module Google
    
    describe Scraper do   
      it "should give you google site backlinks" do
        @g = Scraper.new "link:www.bestbuy.com"
        @g.page_data.should > 0  
      end

      it "should give you google site saturation" do
        @g = Scraper.new "site:www.amishtables.com"
        @g.page_data.should > 0 
      end 
    end

    describe PageRank do   
      it "should give you the sites page rank" do
        @page_rank = PageRank.new("www.bestbuy.com").parse
        @page_rank.should > 0
      end

      it "should return 0 because the URL is not found" do
        @page_rank = PageRank.new("www.bsssestbuy.com").parse
        @page_rank.should == 0
      end
    end
    
  end
end