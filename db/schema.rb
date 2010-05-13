# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090521202952) do

  create_table "articles", :force => true do |t|
    t.integer  "writer_id"
    t.decimal  "cost",          :precision => 9, :scale => 2, :default => 0.0
    t.integer  "rating"
    t.integer  "project_id"
    t.string   "filename"
    t.boolean  "published",                                   :default => false
    t.datetime "created_at"
    t.datetime "updated"
    t.string   "title"
    t.string   "published_url"
    t.integer  "user_id"
    t.integer  "category_id"
  end

  create_table "bj_config", :primary_key => "bj_config_id", :force => true do |t|
    t.text "hostname"
    t.text "key"
    t.text "value"
    t.text "cast"
  end

  create_table "bj_job", :primary_key => "bj_job_id", :force => true do |t|
    t.text     "command"
    t.text     "state"
    t.integer  "priority"
    t.text     "tag"
    t.integer  "is_restartable"
    t.text     "submitter"
    t.text     "runner"
    t.integer  "pid"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.text     "env"
    t.text     "stdin"
    t.text     "stdout"
    t.text     "stderr"
    t.integer  "exit_status"
  end

  create_table "bj_job_archive", :primary_key => "bj_job_archive_id", :force => true do |t|
    t.text     "command"
    t.text     "state"
    t.integer  "priority"
    t.text     "tag"
    t.integer  "is_restartable"
    t.text     "submitter"
    t.text     "runner"
    t.integer  "pid"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.text     "env"
    t.text     "stdin"
    t.text     "stdout"
    t.text     "stderr"
    t.integer  "exit_status"
  end

  create_table "categories", :force => true do |t|
    t.integer  "project_id"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "previous_rank"
    t.integer  "current_rank"
    t.date     "last_ranked"
    t.integer  "user_id",       :default => 1
  end

  create_table "link_types", :force => true do |t|
    t.string "permalink"
    t.string "name"
  end

  create_table "links", :force => true do |t|
    t.integer "project_id"
    t.string  "url"
    t.string  "anchor_text"
    t.integer "keyword_id"
    t.date    "created_at"
    t.date    "updated_at"
    t.integer "page_rank"
    t.string  "backlink"
    t.boolean "nofollow"
    t.date    "backlink_verified_on"
    t.integer "user_id"
    t.integer "link_type_id"
  end

  create_table "project_ranks", :force => true do |t|
    t.integer  "project_id"
    t.integer  "google_links"
    t.integer  "yahoo_links"
    t.integer  "msn_links"
    t.integer  "page_rank"
    t.datetime "created_at"
    t.integer  "alexa_rank"
  end

  create_table "project_users", :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "projects", :force => true do |t|
    t.string  "url"
    t.text    "overview"
    t.text    "goals"
    t.text    "target_markets"
    t.boolean "active",         :default => true
    t.integer "user_id",        :default => 1
    t.text    "article_topics"
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

  create_table "rank_reports", :force => true do |t|
    t.integer "project_id"
    t.date    "created_at"
    t.date    "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.string   "filename"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "roles", :force => true do |t|
    t.string "name", :limit => 11
  end

  create_table "search_engines", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string  "username"
    t.string  "password"
    t.integer "role_id"
    t.boolean "superadmin"
    t.integer "writer_id"
    t.boolean "send_notifications"
  end

  create_table "writers", :force => true do |t|
    t.string "name"
    t.string "company"
    t.string "email"
    t.string "phone"
    t.string "url"
    t.text   "expertise"
    t.text   "fields"
  end

end
