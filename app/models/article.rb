class Article < ActiveRecord::Base
  acts_as_reportable :only => ['title', 'status', 'published_url'], :methods => [:created_at_formatted]

  file_column :filename
  belongs_to :writer
  belongs_to :project

  belongs_to :category
  
  def status
    self.published ? 'Published' : 'Drafted'
  end
  
  def created_at_formatted
    self.created_at.strftime("%m/%d/%Y")
  end
  
end