class ArticlesController < HomeController
  active_scaffold :articles do |config|
    config.list.columns = [:created_at, :title, :category_id, :author, :rating, :published]           
    config.create.columns = [:title, :filename, :category_id, :project_id, :writer_id, :cost, :rating, :published, :published_url]  
    config.update.columns = [:title, :filename, :category_id, :project_id, :writer_id, :cost, :rating, :published, :published_url]   
    config.list.per_page = 50
    config.list.sorting = { :created_at => :desc}
    
    config.columns[:category_id].css_class = 'align-left'
  end
  
  def categories
    @page_title = 'Articles >> Categories'
  end
  
  def initialize_page
    super
    @tab = 'ARTICLES'     
  end
  
  def list
    @page_title = 'Articles'
    super
  end
    
  def conditions_for_collection 
    extra_conditions = ''
    extra_conditions = "AND writer_id = #{@current_user.writer_id}" if @current_user.writer? 
    build_conditions_for_collection(:extra_condition => extra_conditions)      
  end
  
  def before_create_save(record)
    record.user_id = session[:user_id]
    record.project_id = session[:project_id] if record.project_id.blank?
    record.writer_id = @current_user.writer_id if @current_user.writer?
  end

  protected
  
  # only authenticated users are authorized to create records
  def create_authorized?
    @current_user.staff? || @current_user.writer?
  end

  def update_authorized?
    @current_user.staff? || @current_user.writer?
  end

  def delete_authorized?
    @current_user.can_modify?
  end    
  
  def writer_authorized?
    false
  end
    
end