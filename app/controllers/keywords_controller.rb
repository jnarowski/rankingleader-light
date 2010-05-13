class KeywordsController < HomeController
  active_scaffold :keywords do |config|
    config.columns = [:name, :previous_rank, :current_rank, :change_in_rank, :last_ranked]           
    config.list.per_page = 50
    config.columns[:current_rank].css_class = 'align-center'
    config.columns[:previous_rank].css_class = 'align-center'
  end   
  
  def initialize_page
    super
    @tab = 'KEYWORDS'     
  end
  
  def list    
    @page_title = 'Keywords'
    super
  end
  
  def conditions_for_collection        
    build_conditions_for_collection
  end 

  def before_create_save(record)
    record.user_id = session[:user_id]
    record.project_id = session[:project_id]
  end
  
  def bulk_new
    @page_title = 'Bulk Import Keywords'  
  end
  
  def bulk_create   
    Keyword.bulk_import(params[:bulk_keywords], session[:project_id])        
    flash[:message] = 'Your keywords have been successfully imported'
    redirect_to :action => :list
  end
  
  def export
    @keywords = Keyword.find(:all, :conditions => ["project_id = ?", @current_project.id])
    render :layout => false
  end
  
  protected
  
  # only authenticated users are authorized to create records
  def create_authorized?
    @current_user.can_modify?
  end

  def update_authorized?
    @current_user.can_modify?
  end

  def delete_authorized?
    @current_user.can_modify?
  end
    
end