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

ActiveRecord::Schema[7.2].define(version: 2025_10_15_075345) do
  create_table "c_class_networks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "project_id"
    t.string "value"
    t.text "shuize_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_c_class_networks_on_project_id"
  end

  create_table "config_items", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
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
    t.boolean "is_waf", comment: "该IP是否是WAF的ip，例如cloudflare, cloudfront 的。是的话就没必要扫描了"
    t.boolean "is_detected_by_nmap"
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
    t.string "domain_protocol", default: "https", comment: "可以用的值: http/https"
    t.bigint "project_id"
    t.boolean "is_detected_by_wafwoof", default: false
    t.boolean "is_detected_by_dig", default: false
    t.boolean "is_detected_by_observer_ward", default: false
    t.boolean "is_detected_by_ehole", default: false
    t.boolean "is_detected_by_wappalyzer", default: false
    t.boolean "is_detected_by_the_harvester", default: false
    t.boolean "is_detected_by_nuclei_https", default: false
    t.boolean "is_detected_by_nuclei_http", default: false
    t.boolean "is_detected_by_nuclei_manual", default: false
    t.integer "max_severity_in_nuclei_result"
    t.float "max_security_severity", default: 0.0
    t.boolean "is_server_maybe_down", default: false, comment: "maybe this server is down? (80, 443 port closed? )"
    t.boolean "is_confirmed_behind_waf"
    t.boolean "is_confirmed_not_behind_waf"
    t.boolean "is_stared", default: false
    t.boolean "is_detected_by_dirsearch", default: false, comment: "is detected by dirsearch"
    t.text "dirsearch_result"
    t.text "nmap_result_for_special_ports"
    t.integer "response_code", comment: "服务器返回码，200, 301, 404 .."
    t.boolean "is_detected_by_nmap", default: false, comment: "是否被nmap檢測過"
    t.text "nmap_result", comment: "nmap掃描結果"
    t.boolean "is_detected_by_gobuster", comment: "是否被gobuster检查过"
    t.text "gobuster_result", comment: "gobuster的结果"
    t.boolean "is_detected_by_wpscan", comment: "是否被wpscan检测过"
    t.text "wpscan_result", size: :long, comment: "wpscan结果"
    t.string "wpscan_usernames", comment: "wordpress用户名，给wpscan爆破用"
    t.string "wpscan_url", comment: "wpscan 最终探测的url"
    t.text "whatweb_result", comment: "whatweb result"
    t.text "favicon_hash_of_fofa_result"
    t.boolean "is_detected_by_favihunter"
    t.boolean "is_detected_by_fofa", comment: "是否在fofa上检测了"
    t.text "title_of_fofa", comment: "fofa的title"
    t.integer "subdomain_count_main_domain_of_fofa_result", comment: "fofa下查询到的子域名记录, 例如 a.com"
    t.integer "subdomain_count_base_name_of_fofa_result", comment: "fofa下查询到的子域名记录, 例如 domain*=\"*.a.*\""
    t.integer "subdomain_count_favicon_of_fofa_result", comment: "fofa下查询到的子域名记录, 例如： favicon=-11100011"
    t.integer "subdomain_total_count_of_fofa_result"
    t.boolean "is_need_to_fetch_from_fofa", default: false, comment: "是否需要从fofa 手动抓取数据, 仅用于该数据量很大，或者已经抓取过了"
    t.string "favicon_hash_of_fofa", comment: "favicon_hash, of fofa, MMH3"
    t.string "favicon_url", comment: "favicon url, e.g. http://a.com/favicon.ico  http://b.com/logo.jpg"
    t.boolean "is_to_query_fofa_by_main_domain", default: true, comment: "是否查询 host=\"a.com\""
    t.boolean "is_to_query_fofa_by_base_name", default: true, comment: "是否查询 host*=\"*.a.*\""
    t.boolean "is_to_query_fofa_by_icon_hash", default: true, comment: "是否查询 icon_hash=\"1234\""
    t.index ["domain_protocol"], name: "index_servers_on_domain_protocol"
    t.index ["is_confirmed_behind_waf"], name: "index_servers_on_is_confirmed_behind_waf"
    t.index ["is_confirmed_not_behind_waf"], name: "index_servers_on_is_confirmed_not_behind_waf"
    t.index ["is_detected_by_dig"], name: "index_servers_on_is_detected_by_dig"
    t.index ["is_detected_by_dirsearch"], name: "index_servers_on_is_detected_by_dirsearch"
    t.index ["is_detected_by_ehole"], name: "index_servers_on_is_detected_by_ehole"
    t.index ["is_detected_by_favihunter"], name: "index_servers_on_is_detected_by_favihunter"
    t.index ["is_detected_by_fofa"], name: "index_servers_on_is_detected_by_fofa"
    t.index ["is_detected_by_gobuster"], name: "index_servers_on_is_detected_by_gobuster"
    t.index ["is_detected_by_nmap"], name: "index_servers_on_is_detected_by_nmap"
    t.index ["is_detected_by_nuclei_http"], name: "index_servers_on_is_detected_by_nuclei_http"
    t.index ["is_detected_by_nuclei_https"], name: "index_servers_on_is_detected_by_nuclei_https"
    t.index ["is_detected_by_nuclei_manual"], name: "index_servers_on_is_detected_by_nuclei_manual"
    t.index ["is_detected_by_observer_ward"], name: "index_servers_on_is_detected_by_observer_ward"
    t.index ["is_detected_by_the_harvester"], name: "index_servers_on_is_detected_by_the_harvester"
    t.index ["is_detected_by_wafwoof"], name: "index_servers_on_is_detected_by_wafwoof"
    t.index ["is_detected_by_wappalyzer"], name: "index_servers_on_is_detected_by_wappalyzer"
    t.index ["is_detected_by_wpscan"], name: "index_servers_on_is_detected_by_wpscan"
    t.index ["is_need_to_fetch_from_fofa"], name: "index_servers_on_is_need_to_fetch_from_fofa"
    t.index ["is_stared"], name: "index_servers_on_is_stared"
    t.index ["is_to_query_fofa_by_base_name"], name: "index_servers_on_is_to_query_fofa_by_base_name"
    t.index ["is_to_query_fofa_by_icon_hash"], name: "index_servers_on_is_to_query_fofa_by_icon_hash"
    t.index ["is_to_query_fofa_by_main_domain"], name: "index_servers_on_is_to_query_fofa_by_main_domain"
    t.index ["level"], name: "index_servers_on_level"
    t.index ["name"], name: "index_servers_on_name"
    t.index ["project_id"], name: "index_servers_on_project_id"
    t.index ["response_code"], name: "index_servers_on_response_code"
    t.index ["subdomain_count_base_name_of_fofa_result"], name: "index_servers_on_subdomain_count_base_name_of_fofa_result"
    t.index ["subdomain_count_favicon_of_fofa_result"], name: "index_servers_on_subdomain_count_favicon_of_fofa_result"
    t.index ["subdomain_count_main_domain_of_fofa_result"], name: "index_servers_on_subdomain_count_main_domain_of_fofa_result"
  end
end
