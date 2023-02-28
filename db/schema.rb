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

ActiveRecord::Schema[7.0].define(version: 2023_02_28_021417) do
  create_table "c_class_networks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "project_id"
    t.string "value"
    t.text "shuize_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_c_class_networks_on_project_id"
  end

  create_table "emails", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "server_id"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.index ["project_id"], name: "index_emails_on_project_id"
    t.index ["server_id"], name: "index_emails_on_server_id"
  end

  create_table "ip_mappings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "ip_id"
    t.integer "server_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ips", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ip"
    t.text "nmap_result", size: :long
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "location"
  end

  create_table "managers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "servers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.text "comment"
    t.text "wafwoof_result"
    t.text "dig_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pure_ip"
    t.text "title"
    t.string "os_type"
    t.string "web_server"
    t.string "web_framework"
    t.string "web_language"
    t.text "observer_ward_result"
    t.text "ehole_result"
    t.integer "level", comment: "level 0 is the most important"
    t.text "wappalyzer_result"
    t.text "the_harvester_result", size: :long
    t.text "nuclei_https_result", size: :long
    t.text "nuclei_http_result", size: :long
    t.text "nuclei_manual_result", size: :long
    t.string "domain_protocal", default: "https", comment: "可以用的值: http/https"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_servers_on_project_id"
  end

end
