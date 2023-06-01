ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

puts "== should cap nmap as root, refer to: "
def run servers
  puts "== servers.count"
  servers.each do |server|
    puts "== checking server: #{server.name}, index: #{server.id}"
    result_file = "nmap_result_#{server.name}"
    command = "nmap --privileged -sS -p 22,23,3389,5632,5900,1090-1099,7001,8000,8080,8161,9043,50000,50070,389,1433,1521,3306,5432,5984,6379,9200,11211,27017,21,25,53,161,443,445,873,2181,2375 #{server.name}"
    RunJob.perform_later command: command, entity: server, attribute: "nmap_result_for_special_ports"
  end
end

#run Server.where('project_id = 5 and is_confirmed_not_behind_waf = 1 and ehole_result not like "%not work%" and is_detected_by_dirsearch = 0', ).order('level asc')
#run Server.where('project_id = 5 and id = 12133', ).order('level asc')
run Server.where('project_id = 5 and is_confirmed_not_behind_waf = 1', ).order('level asc')
