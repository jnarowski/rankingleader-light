class LinkTypesController < HomeController
  active_scaffold :link_types do |config|
    config.columns = [:name, :permalink]          
  end
  
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