require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe ProjectRank do
  before(:each) do
    @project = create_valid_project
  end

  it "should get new ranks for the single project" do 
    @project.get_new_ranks
    ProjectRank.all.size.should == 1
  end

  it "should create a new project rank" do 
    @project.get_new_ranks
    @pr = ProjectRank.first
    @pr.project_id.should == @project.id
    @pr.google_links.should be > 0
    @pr.yahoo_links.should be > 0
    @pr.page_rank.should be > 0  
  end
  
  it "should set all the projects keyword ranks" do 
    @project2 = create_valid_project(:url => 'www.amishrecipes.net')
    @project3 = create_valid_project(:url => 'www.amishtables.com')  
    ProjectRank.get_all_ranks
    ProjectRank.all.size.should == 3
  end
  
end