ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

# 注意：
# 这里不应该轮训所有 server ( 域名）
# 而是应该直接访问ip

def run ips
  puts "== ips.count: #{ips.size}"
  ips.each do |ip|
    command = "nmap -sS #{ip.ip}"
    RunJob.perform_later command: command, entity: ip, result_column: "nmap_result", is_detected_by_column: :is_detected_by_nmap
  end
end

ips = Ip.joins(:servers)
  .select("DISTINCT ips.*")
  .where('servers.is_confirmed_not_behind_waf = ?',true)
  #.limit(10)

run ips
