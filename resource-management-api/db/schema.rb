# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_12_19_212820) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "organizations", force: :cascade do |t|
    t.string "name"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name"
    t.string "email"
    t.string "phone"
    t.bigint "workgroup_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_profiles_on_organization_id"
    t.index ["workgroup_id"], name: "index_profiles_on_workgroup_id"
  end

  create_table "profiles_users", id: false, force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.bigint "user_id", null: false
    t.index ["profile_id", "user_id"], name: "index_profiles_users_on_profile_id_and_user_id"
    t.index ["user_id", "profile_id"], name: "index_profiles_users_on_user_id_and_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workgroups", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "profiles", "organizations"
  add_foreign_key "profiles", "workgroups"
end
