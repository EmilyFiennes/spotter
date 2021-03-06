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

ActiveRecord::Schema.define(version: 20161128165039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "address"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "cancelled_at"
    t.integer  "activity_id"
    t.string   "level"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "max_participants"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "available",        default: true
    t.index ["activity_id"], name: "index_events_on_activity_id", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "cancelled_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["event_id"], name: "index_participations_on_event_id", using: :btree
    t.index ["user_id"], name: "index_participations_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "facebook_picture_url"
    t.string   "address"
    t.string   "gender"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "token_expiry"
    t.string   "messenger_id"
    t.string   "picture_stamp"
    t.json     "session"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "events", "activities"
  add_foreign_key "events", "users"
  add_foreign_key "participations", "events"
  add_foreign_key "participations", "users"
end
