ActionController::Routing::Routes.draw do |map|     
  map.resources :project_ranks
  
  map.connect '', :controller => 'home'
  map.connect '/login', :controller => 'home', :action => 'login'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
