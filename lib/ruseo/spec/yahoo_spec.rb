require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

module Ruseo
  module Yahoo
    describe Explorer do   
      it "should give you yahoo site backlinks" do
        @y = Explorer.inlink_data "www.bestbuy.com"
        @y.should be > 0
      end
      
      it "should give you yahoo site saturation" do
        @y = Explorer.page_data "www.bestbuy.com"
        @y.should be > 0
      end
    end
  end
end