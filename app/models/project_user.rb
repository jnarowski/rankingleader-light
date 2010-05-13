class ProjectUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  def to_label
    self.project.url
  end
  
end