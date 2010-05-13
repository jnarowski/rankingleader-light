class Keyword < ActiveRecord::Base     
  acts_as_reportable :only => ['name', 'current_rank', 'previous_rank'], :methods => [:change_in_rank, :last_ranked_formatted]
  belongs_to :project
  
  def before_save
    self.name.downcase unless self.name.blank?
  end
  
  def clear_last_ranked!
    self.last_ranked = nil 
    self.previous_rank = nil
    self.current_rank = nil
    self.save
  end
    
  def change_in_rank
    if self.current_rank && self.previous_rank 
      change = (self.current_rank || 0) - (self.previous_rank || 0)  
      if change > 0
        return "+#{ change }"
      elsif change < 0
        return "-#{ change *-1 }"    
      else
        return "-"   
      end
    end  

  end
  
  def last_ranked_formatted
    self.last_ranked.strftime("%m/%d/%Y") if self.last_ranked
  end
  
  # set the current and previous ranks unless otherwise set
  def set_ranks
    clear_last_ranked!
    set_current_rank
    set_previous_rank
    set_last_ranked
    save
  end
    
  # set the most recent google rank for the provided keyword 
  def set_current_rank   
    if !self.current_rank
      results = get_keyword_rank
      if results && results.first
        self.current_rank = results.first.rank   
        self.save   
      end
    end    
  end
  
  # sets the previous google rank for the provided keyword
  def set_previous_rank     
    if !self.previous_rank       
      results = get_keyword_rank  
      if results && results[1]        
        self.previous_rank = results[1].rank   
        self.save   
      end
    end        
    self.previous_rank
  end
  
  def set_last_ranked
    self.last_ranked = Date.today  if self.current_rank
  end
  
  # ---------------------------------------------------------
  # Class Level Methods
  # ---------------------------------------------------------

  def self.bulk_import(bulk_keywords, project_id)
    keywords = bulk_keywords.split(/\r\n/)     
    if keywords && keywords.size > 0
      keywords.each {|keyword| Keyword.create(:name => keyword, :project_id => project_id) }       
    end
  end
  
  # ---------------------------------------------------------
  # Custom SQL Methods
  # ---------------------------------------------------------      
  
  def get_keyword_rank(search_engine_id = SearchEngine::GOOGLE)                                         
    RankReportResult.find_by_sql("SELECT rank_report_results.rank, rank_report_results.links_to, rank_report_results.created_at
      FROM rank_reports 
      LEFT join rank_report_results ON rank_reports.id = rank_report_results.rank_report_id AND keyword_id = #{ self.id }
        WHERE rank_report_results.search_engine_id = '#{ search_engine_id }' AND rank_reports.project_id = #{ self.project_id }
        ORDER BY rank_report_results.created_at DESC
        LIMIT 2")          
  end
    
end