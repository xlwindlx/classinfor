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

ActiveRecord::Schema.define(version: 20170808080917) do

  create_table "buildings", force: :cascade do |t|
    t.integer  "number"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.string   "loc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lectures", force: :cascade do |t|
    t.string   "name"
    t.string   "professor"
    t.integer  "semaster"
    t.integer  "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "majors", force: :cascade do |t|
    t.string   "name"
    t.string   "loc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_room_comments_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer  "building"
    t.string   "department"
    t.integer  "floor"
    t.string   "loc"
    t.integer  "capacity"
    t.integer  "level"
    t.integer  "building_id"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "time_classes", force: :cascade do |t|
    t.string   "week"
    t.integer  "st"
    t.integer  "fi"
    t.integer  "lecture_id"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timetable_majors", force: :cascade do |t|
    t.string   "div"
    t.string   "title"
    t.integer  "grades"
    t.integer  "grade"
    t.string   "subject"
    t.string   "proffesion"
    t.string   "day"
    t.string   "time"
    t.string   "classroom"
    t.string   "validation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timetable_normals", force: :cascade do |t|
    t.string   "div"
    t.string   "title"
    t.integer  "grades"
    t.string   "day"
    t.string   "time"
    t.string   "proffesion"
    t.string   "classroom"
    t.string   "validation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
