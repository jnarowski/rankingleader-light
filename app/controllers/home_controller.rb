class HomeController < ApplicationController                     
  before_filter :authorize, :except => [:login]
  before_filter :initialize_page, :except => [:select_project, :switch_project, :login]
    
  def login
    if request.get?
      session[:user_id] = nil
      @user = User.new
      render :action => 'login'
    else
      @user = User.new(params[:user])
      if @user.login
        session[:user_id] = @user.id
        session[:client] = true if @user.client?
        
        if @user.writer_id 
          redirect_to :action => 'index', :controller => 'articles'
        elsif session[:project_id]  
          redirect_to :action => 'show', :controller => 'projects', :id => session[:project_id]
        else
          redirect_to :action => 'index'
        end
        
      else
        render :action => 'login'
      end
    end
  end
  
  def authorize        
    if session[:user_id]
      @current_user = current_user
    else
      redirect_to :action => :login, :controller => 'home'
    end  
  end                  
  
  def current_user
    User.find(session[:user_id], :include => [:role])
  end
  
  def initialize_page
    if session[:project_id]
      @current_project = Project.find(:first, :conditions => ["id = ? ", session[:project_id]])  
    else
      redirect_to '/home/select_project'
    end
  end
  
  def index
  end
  
  def select_project  
    @page_title = 'Select Project'
  end
  
  def switch_project    
    session[:project_id] = params[:project_id] unless params[:project_id].to_i == 0
  end
    
end