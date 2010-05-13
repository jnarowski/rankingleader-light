class WritersController < HomeController
  active_scaffold :writers do |config|
    config.columns = [:name, :company, :email, :phone, :url] 
  end
  
  def list   
    @page_title = 'Writers'
    super   
  end
end