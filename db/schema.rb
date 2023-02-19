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

ActiveRecord::Schema[7.0].define(version: 2023_02_19_003835) do
  create_table "ip_mappings", charset: "utf8", force: :cascade do |t|
    t.integer "ip_id"
    t.integer "server_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ips", charset: "utf8", force: :cascade do |t|
    t.string "ip"
    t.text "nmap_result", size: :long
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "location"
  end

  create_table "servers", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.text "comment", size: :medium
    t.text "wafwoof_result", size: :medium
    t.text "dig_result", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pure_ip"
    t.text "title", size: :medium
    t.string "os_type"
    t.string "web_server"
    t.string "web_framework"
    t.string "web_language"
    t.text "observer_ward_result", size: :medium
    t.text "ehole_result", size: :medium
    t.integer "level", comment: "level 0 is the most important"
    t.text "wappalyzer_result", size: :medium
    t.text "the_harvester_result", size: :long
    t.text "nuclei_https_result", size: :long
    t.text "nuclei_http_result", size: :long
    t.text "nuclei_manual_result", size: :long
  end

end
