require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe RankReport do
  before(:each) do  
    @metaspring_project = create_valid_project
    @amishrecipes_project = create_valid_project(:url => 'www.amishrecipes.net')
    RankReport.delete_all
    RankReportResult.delete_all
  end

  it "should create a rank report for each of the 3 keywords" do 
    RankReport.import_from_csv(@metaspring_project.id, File.open(RAILS_ROOT + '/test/files/metaspring.csv').read)
    RankReport.all.size.should == 3
  end

  it "should add three keywords to the project" do 
    RankReport.import_from_csv(@metaspring_project.id, File.open(RAILS_ROOT + '/test/files/metaspring.csv').read)
    Keyword.all.size.should == 3
  end

  it "should add one keyword to the project since the other two already exist" do 
    Keyword.create(:project_id => @metaspring_project.id, :name => 'ann arbor web design')
    Keyword.create(:project_id => @metaspring_project.id, :name => 'michigan web design')
    RankReport.import_from_csv(@metaspring_project.id, File.open(RAILS_ROOT + '/test/files/metaspring.csv').read)
    Keyword.all.size.should == 3
  end
      
  it "should not create any reports since the wrong keyword report was uploaded" do 
    lambda { RankReport.import_from_csv(@amishrecipes_project.id, File.open(RAILS_ROOT + '/test/files/metaspring.csv').read) }.should raise_error    
  end

end