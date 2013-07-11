# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130711082432) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "api_key"
    t.integer  "pages_external_id"
    t.string   "role"
    t.datetime "synced_templates_at"
    t.integer  "plan_id"
    t.string   "timezone"
    t.boolean  "super_user"
    t.integer  "company_id"
  end

  add_index "accounts", ["api_key"], :name => "index_accounts_on_api_key"
  add_index "accounts", ["email"], :name => "index_accounts_on_email"

  create_table "apps", :force => true do |t|
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bulk_imports", :force => true do |t|
    t.integer  "account_id"
    t.string   "state"
    t.text     "output"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "record"
    t.string   "csv_file_name"
    t.string   "csv_file_content_type"
    t.integer  "csv_file_size"
    t.datetime "csv_updated_at"
    t.text     "domain_ids"
    t.text     "page_ids"
  end

  create_table "categories", :force => true do |t|
    t.integer  "page_id"
    t.integer  "external_id"
    t.string   "permalinks"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "position"
  end

  create_table "categories_documents", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "document_id"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "timezone"
  end

  create_table "documents", :force => true do |t|
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
    t.string   "title"
    t.datetime "published_at"
    t.datetime "edited_at"
    t.datetime "last_modified_at"
    t.integer  "template_id"
    t.string   "description"
    t.integer  "app_id"
    t.integer  "permalink_id"
    t.string   "content_hash"
    t.integer  "page_id"
    t.integer  "external_id"
    t.integer  "author_id"
    t.integer  "category_id"
    t.decimal  "latitude",         :precision => 10, :scale => 6
    t.decimal  "longitude",        :precision => 10, :scale => 6
    t.string   "kind"
    t.string   "markup"
    t.string   "timezone"
    t.text     "content_html"
  end

  add_index "documents", ["slug"], :name => "index_documents_on_slug"
  add_index "documents", ["template_id"], :name => "index_documents_on_template_id"

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "wildcard"
  end

  add_index "domains", ["name"], :name => "index_domains_on_domain_name"
  add_index "domains", ["page_id"], :name => "index_domains_on_page_id"

  create_table "packages", :force => true do |t|
    t.string   "name"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
    t.string   "description"
    t.string   "thumbnail"
    t.integer  "position"
    t.boolean  "published"
  end

  create_table "packages_presets", :id => false, :force => true do |t|
    t.integer "package_id"
    t.integer "preset_id"
  end

  create_table "pages", :force => true do |t|
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_language"
    t.string   "permalinks"
    t.string   "title"
    t.string   "description"
    t.integer  "domain_id"
    t.string   "name"
    t.integer  "external_id"
    t.integer  "template_id"
    t.integer  "documents_external_id"
    t.boolean  "sitemap"
    t.boolean  "feed"
    t.text     "robots_txt"
    t.string   "google_analytics_tracking_code"
    t.string   "redirect_to"
    t.integer  "categories_external_id"
    t.string   "label"
    t.datetime "published_at"
    t.string   "http_server"
    t.boolean  "indexable"
    t.decimal  "latitude",                       :precision => 10, :scale => 6
    t.decimal  "longitude",                      :precision => 10, :scale => 6
    t.boolean  "atom"
    t.boolean  "rss"
    t.boolean  "georss"
    t.boolean  "ogp"
    t.string   "timezone"
  end

  add_index "pages", ["account_id"], :name => "index_pages_on_account_id"

  create_table "permalinks", :force => true do |t|
    t.string   "path"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "custom"
  end

  add_index "permalinks", ["document_id"], :name => "index_edges_on_document_id"
  add_index "permalinks", ["path"], :name => "index_edges_on_path"

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.integer  "domains_limit"
    t.integer  "pages_limit"
    t.integer  "storage_limit"
    t.integer  "users_limit"
    t.integer  "templates_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trial_length"
    t.boolean  "trial_credit_card"
    t.integer  "billing_day_of_month"
    t.integer  "billing_price"
    t.integer  "documents_limit"
  end

  create_table "presets", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "content"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "slug"
    t.string   "resource"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "company_id"
  end

  add_index "resources", ["slug"], :name => "index_resources_on_slug"

  create_table "rewriters", :force => true do |t|
    t.string   "match"
    t.string   "pattern"
    t.string   "replacement"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "snippets", :force => true do |t|
    t.string   "slug"
    t.text     "content"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.datetime "synced_at"
    t.string   "thumbnail"
    t.boolean  "published"
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
