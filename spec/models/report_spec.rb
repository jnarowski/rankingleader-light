require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Report do
  before(:each) do  
    Project.delete_all
    Report.delete_all
    @project = create_valid_project
  end
  
  it "should create the project folder if it does not already exist" do
    r = Report.new(:project_id => Project.first.id)
    r.verify_or_create_dir
    File.exist?(r.abs_path).should be true      
  end

  it "should set the title to 'Stuff'" do
    r = Report.create(:project_id => Project.first.id)
    r.prepare_and_set_title("Stuff")
    r.name.should == 'Stuff'
  end
  
  it "should raise an error when attempting to generate a report before the record is saved" do
    lambda { Report.new(:project_id => @project.id).generate_keyword_report }.should raise_error
  end
  
  it "should create a keyword report within the correct project folder" do
    keyword = create_keyword(:name => 'Test Keyword', :project_id => @project.id, :current_rank => 3, :previous_rank => 10, :last_ranked => Date.today)
    r = Report.create(:project_id => @project.id)
    r.generate_keyword_report
    File.exist?("#{r.abs_path}/#{r.filename}")
  end

  it "should create a link report within the correct project folder" do
    LinkType.create(:permalink => 'website', :name => 'Website')
    link = create_link(:url => 'www.google.com', :link_type_id => LinkType.all.first.id)
    r = Report.create(:project_id => @project.id)
    r.generate_link_report
    File.exist?("#{r.abs_path}/#{r.filename}")
  end

  it "should create an article report within the correct project folder" do
    create_article(:title => 'Saving Money while having fun', :published_url => 'www.google.com/good')
    r = Report.create(:project_id => @project.id)
    r.generate_article_report
    File.exist?("#{r.abs_path}/#{r.filename}")
  end
  
  it "should create an project report within the correct project folder" do
    # prepare the report
    create_article(:title => 'Saving Money while having fun', :published_url => 'www.google.com/good')
    LinkType.create(:permalink => 'website', :name => 'Website')
    create_link(:url => 'www.google.com', :link_type_id => LinkType.all.first.id)
    
    rank1 = create_project_rank(:google_links => 100, :yahoo_links => 200, :page_rank => 5); rank1.created_at = Date.today - 20; rank1.save
    rank2 = create_project_rank(:google_links => 110, :yahoo_links => 230, :page_rank => 5); rank2.created_at = Date.today - 10; rank2.save
    rank3 = create_project_rank(:google_links => 150, :yahoo_links => 250, :page_rank => 5); rank3.created_at = Date.today - 5; rank3.save
    
    r = Report.generate_report('ProjectReport', @project.id, :title => "Project Report")
    File.exist?("#{r.abs_path}/#{r.filename}")
  end
end