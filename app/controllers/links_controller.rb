class LinksController < HomeController
  active_scaffold :links do |config|
    config.columns = [:created_at, :url, :page_rank, :link_type, :anchor_text] 
    config.list.sorting = { :created_at => :desc }   
    config.columns[:page_rank].css_class = 'align-left'
  end  
  
  def initialize_page
    super
    @tab = 'LINKS'     
  end
  
  def list
    @page_title = 'Inbound Links'
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
    @link_types = LinkType.all(:order => 'permalink') 
    @page_title = 'Bulk Import Inbound Links'  
  end
  
  def bulk_create  
    Link.bulk_import(params[:bulk_links], @current_project.id)            
    flash[:message] = 'Your keywords have been successfully imported'    
    redirect_to :action => :list
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