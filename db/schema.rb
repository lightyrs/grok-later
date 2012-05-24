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

ActiveRecord::Schema.define(:version => 20120427172231) do

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
    t.string   "href"
    t.string   "title"
    t.string   "titles"
    t.string   "author"
    t.string   "authors"
    t.text     "lede"
    t.text     "keywords"
    t.text     "sentences"
    t.text     "body"
    t.text     "html_body"
    t.string   "feed"
    t.string   "feeds"
    t.string   "favicon"
    t.text     "description"
    t.datetime "analyzed_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
