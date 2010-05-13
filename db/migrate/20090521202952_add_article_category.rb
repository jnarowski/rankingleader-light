class AddArticleCategory < ActiveRecord::Migration
  def self.up
    add_column :projects, :article_topics, :text 
  end

  def self.down
  end
end
