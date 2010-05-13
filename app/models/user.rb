class User < ActiveRecord::Base          
  has_many :project_users
  has_many :projects, :through => :project_users
  belongs_to :role
  belongs_to :writer
  
  def to_label
    self.username
  end
  
  def client?
    true if self.role.name == 'Client'
  end
  
  def writer?
    true if self.role.name == 'Writer'
  end

  def staff?
    true if self.role.name == 'Staff'
  end
    
  def can_modify?
    true unless (writer? || client?)
  end
  
  # otherwise false is returned.
  def login
    valid = true
    
    if username.blank?
      self.errors.add_to_base("Please enter a user name")
      valid = false
    end	
    
    if password.blank?
      self.errors.add_to_base("Please enter a password")
      valid = false
    end
  		
    if valid
     user = User.find(:first, :conditions => ["username = ? AND password = ?", username, password])
       
      if user
        self.id = user.id
        self.reload
      else
        self.errors.add_to_base("The user name/password was incorrect.")
        valid = false
      end
    end
    
    valid
  end
  
end