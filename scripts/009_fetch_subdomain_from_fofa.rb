ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'optparse'
require 'csv'

def run servers
  puts "=servers: #{servers.size}"

  # 为每个关键词执行搜索任务
  servers.each do |server|
    # 使用Delayed Job异步执行任务
    RunFofaSubdomainJob.perform_later( server: server )
  end
end

# TODO 需要考虑特别大型的结果集的情况，一天消耗 3000块。。。
#
run Server.where('level = 1 and is_need_to_fetch_from_fofa = 1 and project_id = ?', ARGV[0])

#run Server.where('level = 1 and favicon_hash_of_fofa_result = ? and project_id = 4', "Found 0 subdomains, will be saved to servers" )

# 常用命令：
#  Server.where('level = 1 and project_id = 3').order('subdomain_total_count_of_fofa_result desc').limit(100).map {|e| puts "#{e.name}, #{e.subdomain_total_count_of_fofa_result}, #{e.subdomain_count_main_domain_of_fofa_result}, #{e.subdomain_count_base_name_of_fofa_result}, #{e.subdomain_count_favicon_of_fofa_result}" }
#
# twitter.com, 34274950, 34238811, 36139,
# co.za, 8105792, 8105792, ,
# etoro.com, 239026, 239026, ,
# robinhood.com, 168062, 86329, 81733,
# gate.io, 149629, 149629, ,
# binance.com, 57120, 54506, 2614,
# crypto.com, 48873, 48873, ,
# channelnewsasia.com, 41426, 41402, 24,
# gate.com, 26029, 26029, ,
