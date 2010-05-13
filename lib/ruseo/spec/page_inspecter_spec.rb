require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

module Ruseo
  describe PageInspecter do
  
    it "should return a collection of backlinks" do
      page = PageInspecter.new('www.amishrecipes.net', :backlink => 'www.amishtables.com')
      page.find_backlinks
      page.backlinks.size.should > 0
      page.backlinks.first.href.should include 'www.amishtables.com'
    end

    it "should return a collection of backlinks with backlink passed in later" do
      page = PageInspecter.new('www.amishtables.com')
      page.find_backlinks('www.amish-furniture-home.com')
      page.backlinks.size.should > 0
      first_backlink = page.backlinks.first
      first_backlink.href.should include 'www.amish-furniture-home.com'
      first_backlink.text.should include "Amish"
    end
        
    it "should fail because no backlink has been provided" do
      lambda { 
        page = PageInspecter.new('www.amishrecipes.net')
        page.find_backlinks 
      }.should raise_error DataError
    end
          
  end
end