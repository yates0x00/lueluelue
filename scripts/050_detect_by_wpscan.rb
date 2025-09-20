ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'


def detect_by_wpscan servers
  puts "== servers: #{servers.size}"
  servers.each do |server|
    RunWpscanJob.perform_later server
  end
end

# detect_by_wpscan Server.where('project_id = ? and ehole_result like "%200%"', ARGV[0])
#
#
#detect_by_wpscan Server.where('project_id = ?', ARGV[0]).limit(30)
detect_by_wpscan Server.where('project_id = ?', ARGV[0])
puts "== done"
