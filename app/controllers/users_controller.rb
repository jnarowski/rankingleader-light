class UsersController < HomeController
  # active_scaffold :users do |config|
  #   config.columns = [:username, :password, :role_id, :superadmin, :writer_id, :send_notifications, :project_users]            
  # end       
  
  def list   
    if @current_user.superadmin?  
      @page_title = 'Users'   
      super  
    else
      redirect_to '/home'  
    end
  end
end
