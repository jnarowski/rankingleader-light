require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

module Ruseo
  describe Page do
  
    it "should open a webpage" do
      page = Page.new('cnn.com')
      page.data.should_not be nil
    end

    it "should open a webage after reformatting the url" do
      page = Page.new('www.cnn.com')
      page.data.should_not be nil
    end

    it "should raise an error since the url is not found" do
      lambda { Page.new('http://cnnsss.com') }.should raise_error(NotFoundError)  
    end
          
  end
end