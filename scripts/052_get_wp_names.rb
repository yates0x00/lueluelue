ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'

def run servers
  puts "=== servers.size: #{servers.size}"
  servers.each do |server|
    RunGetWpUsernameJob.perform_later server
  end
end

run Server.where('project_id = ? and wpscan_usernames is null', ARGV[0])
