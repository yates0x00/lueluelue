ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'

puts "== 运行这个，非常必要，否则会把fofa的点数都消耗完。medium, okx , id ,  几十万的结果起步"
puts "== make sure only run 4 delayed job daemon, fofa require 2req/s"

def run servers
  puts "=servers: #{servers.size}"

  # 为每个关键词执行搜索任务
  servers.each do |server|
    # 使用Delayed Job异步执行任务
    RunFofaSubdomainCountJob.perform_later( server: server )
  end
end

# TODO 需要考虑特别大型的结果集的情况，一天消耗 3000块。。。
# run Server.where('project_id = ?', ARGV[0])
#
#run Server.where('level = 1 and favicon_hash_of_fofa_result = ? and project_id = 4', "Found 0 subdomains, will be saved to servers" )
run Server.where('level = 1 and project_id =? ', ARGV[0])


# 说明：该脚本非常重要，因为下列权重高的站点，完全不能使用默认的策略（ "a.com" , 而是需要 domain*="*.a.*" 和 icon_hash = xxx )
