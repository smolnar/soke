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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150307122001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "queries", force: true do |t|
    t.string   "value",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "queries", ["value"], name: "index_queries_on_value", unique: true, using: :btree

  create_table "results", force: true do |t|
    t.string   "title",       null: false
    t.string   "url",         null: false
    t.text     "description", null: false
    t.string   "bing_uuid",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["bing_uuid"], name: "index_results_on_bing_uuid", using: :btree

  create_table "results_pages", force: true do |t|
    t.integer  "search_id",                  null: false
    t.integer  "result_id",                  null: false
    t.integer  "position",                   null: false
    t.boolean  "clicked",    default: false, null: false
    t.datetime "clicked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results_pages", ["search_id", "result_id"], name: "index_results_pages_on_search_id_and_result_id", unique: true, using: :btree

  create_table "searches", force: true do |t|
    t.integer  "query_id",   null: false
    t.integer  "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["query_id"], name: "index_searches_on_query_id", using: :btree
  add_index "searches", ["session_id"], name: "index_searches_on_session_id", using: :btree

  create_table "sessions", force: true do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

end
