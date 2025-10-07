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
# run Server.where('project_id = ?', ARGV[0])
run Server.where('level = 1 and favicon_hash_of_fofa_result = ? and project_id = 4', "Found 0 subdomains, will be saved to servers" )
