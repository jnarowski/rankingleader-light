class RankReport < ActiveRecord::Base     
  has_many :rank_report_results, :dependent => :delete_all
  
  def self.import_from_csv(project_id, file)  
    index = 0 
    found_project_url = false
          
    RankReport.transaction do
      
      FasterCSV.parse(file) do |data| 
        project = Project.find(project_id)     
        if index > 0
          # create a new report
          rr = RankReport.create(:project_id => project.id) 
           
          # populate the results from the search engines
          rr.build_rank_result(SearchEngine::GOOGLE, data[0], data[1], data[2])     
          rr.build_rank_result(SearchEngine::YAHOO, data[0], data[3], data[4])     
          rr.build_rank_result(SearchEngine::MSN, data[0], data[5], data[6])  
          
          # has the project URL been found at all?
          # this is to combat against accidentially importing the wrong CSV
          found_project_url ||= self.check_url(project.url, [data[2], data[4], data[6]])
        end   
        index += 1
      end
      raise 'Project URL not found any results. Results not imported.' unless found_project_url  
       
    end 
  end 
  
  def self.check_url(url, results)
    success = false
    results.each {|r| success ||= true if (r && r.include?(url)) }
    success
  end
  
  def build_rank_result(search_engine_id, keyword_name, rank, links_to)  
    keyword = Keyword.find_by_name(keyword_name)                                                              
    if keyword   
      keyword.clear_last_ranked! 
    else
      keyword = Keyword.create(:project_id => self.project_id, :name => keyword_name)
    end
    RankReportResult.create(:search_engine_id => search_engine_id, :links_to => links_to, :rank => rank, :keyword_id => keyword.id, :rank_report_id => self.id)     
  end  

  # def self.replace_previous_report?(project_id)
  #   report = RankReport.find(:first, :conditions => ["project_id = ? AND created_at = ? ", project_id, Date.today])     
  #   report.destroy if report  
  # end
     
end  