class RankReportsController < HomeController
  
  def csv_import
    @tab = 'KEYWORDS'
  end
  
  def import_rank_report_from_csv 
    begin   
      RankReport.import_from_csv(session[:project_id], params[:csv][:file])     
      @current_project.set_keyword_ranks   
      flash[:message] = 'CSV Successfully Imported'
    rescue
      flash[:message] = 'Project URL not found any results. Results not imported.'
    end
    redirect_to :action => :list, :controller => :keywords
  end
  
end
