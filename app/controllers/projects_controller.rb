class ProjectsController < HomeController
  # active_scaffold :projects do |config|
  #   config.list.columns = [:url]            
  #   config.create.columns = [:url, :overview, :goals, :target_markets, :article_topics]     
  #   config.update.columns = [:url, :overview, :goals, :target_markets, :article_topics]  
  #   config.show.columns = [:url, :overview, :goals, :target_markets, :keywords]        
  #   config.show.link.inline = false
  # end  
  
  def list
    @page_title = 'Projects' 
    super                    
  end  
    
  def conditions_for_collection          
    ['projects.id IN(?)', Project.user_projects_for_permissions(@current_user.id)]
  end     
  

  def after_create_save(record)
    ProjectUser.create(:project_id => record.id, :user_id => @current_user.id)
  end
 
  def show
    @page_title = "#{ @current_project.url.capitalize } Dashboard"       
    @tab = 'DASHBOARD' 
    
    @last_rank = @current_project.last_rank
    @current_rank = @current_project.current_rank
    
    @recent_articles = @current_project.articles.find(:all, :order => "created_at DESC", :limit => 3)
    super
  end
  
  def generate_report
    start_date = params[:start_date].blank? ? nil : Date.parse(params[:start_date])
    end_date   = params[:end_date].blank?   ? nil : Date.parse(params[:end_date])
  
    @report = Report.generate_report(params[:report_type], @current_project.id, { :start_date => start_date, :end_date => end_date })
    
    if @report
       Notifier.deliver_report_completed(@report, @current_user)
       flash[:message] = 'Your report is being created and will emailed to you once it has been completed.'
       redirect_to "/projects/show/#{@current_project.id}"
    end
  end
  
  def update_report_description
  end
  
  protected
  
  # only authenticated users are authorized to create records
  def create_authorized?
    @current_user.can_modify?
  end

  def update_authorized?
    @current_user.can_modify?
  end

  def show_authorized?
    @current_user.can_modify?
  end
  
  def delete_authorized?
    @current_user.can_modify?
  end
  
end