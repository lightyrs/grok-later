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

ActiveRecord::Schema.define(:version => 20120525182406) do

  create_table "curiosities", :force => true do |t|
    t.integer "subject_id", :null => false
    t.integer "user_id",    :null => false
  end

  create_table "identities", :force => true do |t|
    t.string   "uid"
    t.string   "bio"
    t.string   "username"
    t.string   "provider"
    t.string   "token"
    t.string   "email"
    t.string   "avatar"
    t.string   "profile_url"
    t.string   "location"
    t.integer  "user_id"
    t.integer  "login_count",  :default => 0
    t.datetime "logged_in_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "identities", ["uid", "provider"], :name => "index_identities_on_uid_and_provider", :unique => true
  add_index "identities", ["user_id"], :name => "index_identities_on_user_id"

  create_table "links", :force => true do |t|
    t.string   "href",        :null => false
    t.string   "title"
    t.string   "domain"
    t.text     "authors"
    t.string   "favicon"
    t.text     "lede"
    t.text     "links"
    t.text     "description"
    t.text     "keywords"
    t.text     "body_html"
    t.text     "body_text"
    t.string   "image"
    t.text     "images"
    t.string   "feed"
    t.string   "og_title"
    t.string   "og_image"
    t.integer  "share_count"
    t.datetime "analyzed_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "links", ["href"], :name => "index_links_on_href", :unique => true

  create_table "references", :force => true do |t|
    t.integer "subject_id", :null => false
    t.integer "link_id",    :null => false
  end

  create_table "subjects", :force => true do |t|
    t.string   "name",       :null => false
    t.text     "abstract"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "subjects", ["name"], :name => "index_subjects_on_name", :unique => true

  create_table "subjects_users", :force => true do |t|
    t.integer "subject_id", :null => false
    t.integer "user_id",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
