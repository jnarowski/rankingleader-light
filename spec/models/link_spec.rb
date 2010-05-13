require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Link do
  before(:each) do
    @project = create_valid_project(:url => 'www.amishtables.com')
  end

  it "should set the backlinking information since it was found" do 
    @link = create_link(:url => 'www.amishrecipes.net', :project_id => @project.id)
    @link.verify_backlink
    @link.nofollow.should be false
    @link.backlink.should include 'www.amishtables.com'
    @link.backlink_verified_on.should == Date.today
  end

  it "should bulk import links" do
    links = "www.google.com, website\r\nwww.amazon.com,blog\r\nwww.amishrecipes.net,forum\r\n"
    Link.bulk_import(links, create_valid_project.id)
    Link.all.size.should == 3
  end

  it "should properly classify a single link" do
    LinkType.create(:permalink => 'website', :name => 'Website')
    links = "www.google.com, website"
    Link.bulk_import(links, create_valid_project.id)
    Link.all.size.should == 1
    Link.first.link_type.permalink.should == 'website'
  end

  it "should properly classify two links" do
    LinkType.create(:permalink => 'website', :name => 'Website')
    LinkType.create(:permalink => 'forum', :name => 'Forum')
    
    links = "www.google.com, website\r\nwww.amishrecipes.net, forum\r\n"
    
    Link.bulk_import(links, create_valid_project.id)
    Link.all.size.should == 2
    Link.first.link_type.permalink.should == 'website'
    Link.all[1].link_type.permalink.should == 'forum'
  end
    
end