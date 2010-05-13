class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer "project_id"
      t.integer "parent_id"
      t.string  "name"
      t.string  "type"
      t.timestamps
    end
    
    add_column :articles, :category_id, :integer    
  end

  def self.down
    drop_table :categories
  end
end
