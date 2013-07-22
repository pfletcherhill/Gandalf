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

ActiveRecord::Schema.define(version: 20130713044761) do

  create_table "event_instances", force: true do |t|
    t.integer  "group_id"
    t.integer  "event_id"
    t.string   "apps_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_instances", ["apps_id"], name: "index_event_instances_on_apps_id", using: :btree
  add_index "event_instances", ["event_id"], name: "index_event_instances_on_event_id", using: :btree
  add_index "event_instances", ["group_id"], name: "index_event_instances_on_group_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.string   "room_number"
    t.integer  "organization_id"
    t.integer  "location_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "fb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["organization_id"], name: "index_events_on_organization_id", using: :btree
  add_index "events", ["slug"], name: "index_events_on_slug", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "organization_id"
    t.string   "type"
    t.string   "apps_id"
    t.string   "apps_email"
    t.string   "apps_cal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["apps_id"], name: "index_groups_on_apps_id", using: :btree
  add_index "groups", ["organization_id"], name: "index_groups_on_organization_id", using: :btree
  add_index "groups", ["slug"], name: "index_groups_on_slug", using: :btree

  create_table "location_aliases", force: true do |t|
    t.string   "value"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.text     "bio"
    t.string   "slug"
    t.string   "image"
    t.string   "color",         default: "150,150,150"
    t.string   "fb_id"
    t.string   "fb_access_key"
    t.string   "fb_name"
    t.string   "fb_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", using: :btree

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "subscribeable_id"
    t.string   "subscribeable_type"
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "access_type",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["group_id"], name: "index_subscriptions_on_group_id", using: :btree
  add_index "subscriptions", ["subscribeable_id"], name: "index_subscriptions_on_subscribeable_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "netid"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "college"
    t.string   "year"
    t.string   "division"
    t.boolean  "go_admin"
    t.string   "bulletin_preference", default: "daily"
    t.string   "fb_id"
    t.string   "fb_access_token"
    t.string   "fb_accounts"
    t.string   "apps_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["netid"], name: "index_users_on_netid", using: :btree

end
