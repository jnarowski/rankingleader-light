require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

module Ruseo
  describe Link do

    before(:each) do  
      @link = Link.new({'href' => 'www.google.com', 'rel' => 'nofollow'})
    end
      
    it "should return a valid link" do
      @link.href.should == "www.google.com"
    end
  
    it "should be a nofollow link" do
      @link.nofollow?.should be true
    end
    
    it "should be false since it is not a nofollow link" do
      @link.rel = 'external'
      @link.nofollow?.should be false
    end
              
  end
end