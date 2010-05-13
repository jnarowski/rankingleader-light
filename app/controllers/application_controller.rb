# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  #helper :all # include all helpers, all the time
  protect_from_forgery :only => [:create, :update, :destroy] 

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def build_conditions_for_collection(options = {})
    extra_conditions = ''
    extra_conditions += options[:extra_conditions] if options[:extra_conditions]
    ["project_id IN(?) AND project_id = ? #{extra_conditions}", Project.user_projects_for_permissions(@current_user.id), @current_project.id]
  end
  
end