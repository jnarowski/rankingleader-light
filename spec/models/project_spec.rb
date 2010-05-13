require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Project do
  before(:each) do
    @metaspring_project = create_valid_project
    RankReport.import_from_csv(@metaspring_project.id, File.open(RAILS_ROOT + '/test/files/metaspring.csv').read)
  end

  it "should set all the projects keyword ranks" do 
    @metaspring_project.set_keyword_ranks
    Keyword.all.each {|k| k.current_rank.should be > 0 } 
  end
end