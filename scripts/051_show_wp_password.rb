ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'



# detect_by_wpscan Server.where('project_id = ? and ehole_result like "%200%"', ARGV[0])
#
#
#detect_by_wpscan Server.where('project_id = ?', ARGV[0]).limit(30)
#detect_by_wpscan Server.where('project_id = ?', ARGV[0])
#
#servers = Server.where("name NOT REGEXP ? AND project_id = 2 and wpscan_result like ?",
#    '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(:[0-9]+)?$', '%password_attack%').find_each do |server|

servers = Server.where("name REGEXP ? AND project_id = 2 and wpscan_result like ?",
    '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(:[0-9]+)?$', '%password_attack%').find_each do |server|
  password_attack = JSON.parse(server.wpscan_result)['password_attack']

  if password_attack.present?
    puts "== #{server.domain_protocol}://#{server.name},  #{password_attack}"
  end
end
puts "== done"
