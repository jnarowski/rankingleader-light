class RolesController < HomeController
  active_scaffold :roles do |config|          
  end       
  
  def list   
    if @current_user.superadmin?  
      @page_title = 'Roles'   
      super  
    else
      redirect_to '/home'  
    end
  end
end
