require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Keyword do
  before(:each) do
    Keyword.delete_all
    Project.delete_all
    RankReport.delete_all
    RankReportResult.delete_all
    
    @metaspring_project = create_valid_project
    RankReport.import_from_csv(@metaspring_project.id, File.open(RAILS_ROOT + '/test/files/metaspring.csv').read)
  end

  it "should set the current keyword rank for the provided keyword" do 
    @keyword = Keyword.first
    @keyword.set_ranks
    @keyword.current_rank.should == 3
    @keyword.previous_rank.should be nil
  end

  it "should set the current and previous keyword rank for the provided keyword" do 
    @keyword = Keyword.first
  
    # create the fake previous report
    rr = RankReport.create(:project_id => @metaspring_project.id)
    r = RankReportResult.create(:rank_report_id => rr.id, :rank => 2, :keyword_id => @keyword.id, :search_engine_id => SearchEngine::GOOGLE, :created_at => '2008-01-01')
    r.created_at = '2008-01-01'
    r.save
    
    @keyword.set_ranks 
    @keyword.current_rank.should == 3
    @keyword.previous_rank.should == 2   
  end
  
end