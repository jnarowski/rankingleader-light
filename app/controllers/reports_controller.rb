class ReportsController < HomeController
  active_scaffold :reports do |config|
    config.columns = [:created_at, :name, :project]           
    config.list.per_page = 50
    config.list.sorting = { :created_at => :desc }   
  end

  def list    
    @page_title = 'Reports'
    @tab = 'REPORTS' 
    super
  end
  
  def conditions_for_collection        
    build_conditions_for_collection
  end
    
  protected 
  
  # only authenticated users are authorized to create records
  def create_authorized?
    false
  end

  def update_authorized?
    false
  end

  def delete_authorized?
    @current_user.can_modify?
  end
  
  
end