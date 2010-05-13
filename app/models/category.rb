class Category < ActiveRecord::Base
  def self.default_categories_for_project(project_id)
   ["Blog Post", "Press Release", "Article", "Web Content"].each do |c|
     Category.create(:name => c, :project_id => project_id)
   end
  end
end