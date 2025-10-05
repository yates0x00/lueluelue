ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'optparse'
require 'csv'

# TODO 从这里开始，2025.10.5, 跑通： 0012, 0013, 0013, 0014
def run servers
  # 为每个关键词执行搜索任务
  servers.each do |server|
    # 使用Delayed Job异步执行任务
    RunFofaSubdomainJob.perform_later( server: server )
  end
end

run Server.where('project_id = ?', ARGV[0]).limit 2
