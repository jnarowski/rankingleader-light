class Project < ActiveRecord::Base
  has_many :project_users
  has_many :users, :through => :project_users
  has_many :keywords
  has_many :articles
  
  def clients(options = {})
    conditions = ''
    conditions += options[:conditions] if options[:conditions]
    users.find(:all, :conditions => ["users.role_id = ? #{conditions}", Role::CLIENT])
  end
  
  def client_email_string
    str = ''
    clients(:conditions => 'AND send_notifications = true').each {|c| str += "#{c.username}," }
    str[0..-2] 
  end
     
  def set_keyword_ranks
    self.keywords.each {|k| k.set_ranks }
  end
  
  def get_new_ranks
    ProjectRank.new_project_ranks(self.id)
  end

  def verify_links
    Link.verify_backlinks(self.id)
  end
    
  def to_label
    self.url
  end
  
  def after_create
    Category.default_categories_for_project(self.id)
  end
  
  def before_save
    self.url = self.url.gsub(/www\./, '') 
    self.url = self.url.gsub(/http:\/\//, '')
  end
  
  def last_rank
    rank = ProjectRank.find(:all, :conditions => ["project_id = ? ", self.id], :order => 'created_at DESC', :limit => 2)
    rank[1] if rank && rank[1]
  end
  
  def current_rank
    rank = ProjectRank.find(:all, :conditions => ["project_id = ? ", self.id], :order => 'created_at DESC', :limit => 1)
    rank.first if rank
  end
      
  def self.user_projects_for_permissions(user_id)
    ProjectUser.find(:all, :conditions => ["user_id = ?", user_id]).collect {|pu| pu.project_id} 
  end   
  
  def self.find_with_permission(user_id)
    all(:conditions => ['id IN(?)', Project.user_projects_for_permissions(user_id)])
  end
  
  def self.strip_down(url)  
    url = url.gsub(/http:\/\//, '') 
    url = url.gsub(/www\./, '')
    url = url.split("/")
    url[0] if url && url[0]
  end
    
  def self.verify_backlinks
    Project.find(:all, :conditions => ["active = 1"]).each do |p|
      p.verify_backlinks
    end
  end
end