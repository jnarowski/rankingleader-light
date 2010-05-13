class InitializeDatabase < ActiveRecord::Migration
  def self.up
    create_table "client_users", :force => true do |t|
      t.integer "user_id"
      t.integer "client_id"
    end

    create_table "clients", :force => true do |t|
      t.string "name"
    end

    create_table "keywords", :force => true do |t|
      t.string   "name"
      t.integer  "project_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "links", :force => true do |t|
      t.integer "project_id"
      t.string  "url"
      t.string  "anchor_text"
      t.integer "keyword_id"
      t.date    "created_at"
      t.date    "updated_at"
      t.integer "page_rank"
      t.string  "links_to"
      t.integer "nofollow",            :limit => 1
      t.integer "internal_link_count"
      t.integer "external_link_count"
    end

    create_table "project_users", :force => true do |t|
      t.integer "project_id"
      t.integer "user_id"
    end

    create_table "projects", :force => true do |t|
      t.string  "url"
      t.integer "client_id"
    end

    create_table "users", :force => true do |t|
      t.string  "username"
      t.string  "password"
      t.integer "admin",    :limit => 1
    end
  end

  def self.down
    drop_table "users"
  end
end
