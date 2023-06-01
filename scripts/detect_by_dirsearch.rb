ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

puts "== install dirsearch first"
def run servers
  puts "== servers.count"
  servers.each do |server|
    puts "== checking server: #{server.name}, index: #{server.id}"
    result_file = "dirsearch_result_#{server.name}"
    command = "python3 /workspace/coding_tools/dirsearch/dirsearch.py -e html,js -u #{server.name} -o #{result_file} --proxy=socks5://192.168.1.105:1094"
    RunJob.perform_later command: command
  end
end

#run Server.where('(name not like "%beiersdorf%" and name not like "%nivea%")').order('level asc')
#run Server.where('id >= 9301').order('level asc')
#
#run Server.where('project_id = 5 and is_confirmed_not_behind_waf = 1 and ehole_result not like "%not work%" and is_detected_by_dirsearch = 0', ).order('level asc')
run Server.where('project_id = 5 and is_detected_by_dirsearch = 0', ).order('level asc')
