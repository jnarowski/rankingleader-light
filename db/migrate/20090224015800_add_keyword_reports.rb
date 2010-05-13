class AddKeywordReports < ActiveRecord::Migration
  def self.up
    create_table "rank_reports", :force => true do |t|
      t.integer  "project_id" 
      t.date     "created_at"
      t.date     "updated_at"
    end    

    create_table "rank_report_results", :force => true do |t|
      t.integer  "keyword_id" 
      t.integer  "rank_report_id" 
      t.integer  "rank"  
      t.string   "links_to"  
      t.string   "keyword"    
      t.integer  "search_engine_id"
      t.datetime "created_at"
    end

    create_table "search_engines", :force => true do |t|
      t.string   "name"  
    end
    
    SearchEngine.new(:name => 'Google')   
    SearchEngine.new(:name => 'Live')   
    SearchEngine.new(:name => 'Yahoo')  
    
    add_column :keywords, :previous_rank, :integer 
    add_column :keywords, :current_rank, :integer 
    add_column :keywords, :last_ranked, :date 
  end

  def self.down
  end
end
