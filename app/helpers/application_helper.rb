# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
      
  # clear all floats
  def float_clear
    "<span class=\"float-clear\">&nbsp;</span>"
  end
  
  def tab(title, url, name, options = {})  
    class_name = ''
    class_name = 'selected' if name == @tab
    "<li class=\"#{ class_name }\">#{ link_to(title, url, options) }</li>" 
  end
  
  def project_select       
    if @current_user  
      # collect the projects
      projects = Project.find(:all, :conditions => ['id IN(?)', Project.user_projects_for_permissions(@current_user.id)], :order => 'url').collect {|p| [p.url, p.id]}
      projects.unshift(["Select a Project", 0])
    
      # set the project_id
      project_id = (session[:project_id] ? session[:project_id] : 0).to_i    
    
      # select box
      select_tag('project_id', 
        options_for_select(projects, project_id),
        :onchange => remote_function(:with => "Form.serialize(this.form)", :url => { :action => 'switch_project', :controller => 'home', :current_url => request.request_uri }))
    end
  end    
  
  def page_rank_image(rank, size = 'small_', prefix = 'pr_', style = '')
    final_rank = (rank.to_i && rank.to_i > 0) ? rank : 0
    image_tag("/images/page_rank/#{ prefix }#{ size }#{ final_rank }.jpg", :style => style, :title => "#{final_rank} out of 10", :alt => "#{final_rank} out of 10")
  end

  def format_date(date, format = false)
    format ? date.strftime(format) : date.strftime("%m/%d/%Y") if date unless date.blank?
  end

  def format_money(amount, format = false)
    "$" + sprintf('%0.2f', amount) if amount
  end

  def collect_for_page_rank
    arr = []
    11.times {|i| arr << i }
    arr
  end
  
  # -------------------------------------------------------------------------------
  # Authentication
  # -------------------------------------------------------------------------------

  def current_user
    @current_user
  end
    
  def is_logged_in?
    true if current_user && current_user.id
  end   
  
  def is_admin?
    true if current_user && current_user.superadmin?
  end
   
end