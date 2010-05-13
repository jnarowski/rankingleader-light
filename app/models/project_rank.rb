class ProjectRank < ActiveRecord::Base
  validates_presence_of :google_links, :yahoo_links, :page_rank
  
  def self.new_project_ranks(project_id) 
    if project = Project.find(project_id)
      begin
        pr = ProjectRank.new(:project_id => project.id)
        pr.page_rank = Ruseo::Google::PageRank.new(project.url).parse
        pr.google_links = Ruseo::Google::Scraper.new(project.url).page_data
        pr.yahoo_links = Ruseo::Yahoo::Explorer.inlink_data(project.url)
        pr.save
      rescue 
        #TODO Rescue and Retry?
      end
    end
  end
  
  def self.get_all_ranks
    Project.find(:all, :conditions => ["active = ?", true]).each{ |project| new_project_ranks(project.id) }
  end

  def self.faux_report_table(project_id, options = {})
    table = Table(['Date', 'Google Links', 'Yahoo Links', 'Page Rank'])
    ranks = ProjectRank.all(:conditions => ["project_id = ? ", project_id], :order => 'created_at DESC', :limit => 5)
    ranks.each {|r| table << [r.created_at.strftime("%m/%d/%Y"), r.google_links, r.yahoo_links, r.page_rank] }
    table
  end
  
end