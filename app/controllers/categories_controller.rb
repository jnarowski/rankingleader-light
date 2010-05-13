class CategoriesController < HomeController
  # active_scaffold :categories do |config|
  #   config.columns = [:name]
  # end
  
  def list   
    @page_title = 'Categories'
    super   
  end

  def conditions_for_collection        
    build_conditions_for_collection
  end

  def before_create_save(record)
    record.project_id = session[:project_id] if record.project_id.blank?
  end
  
end