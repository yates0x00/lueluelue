ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'

def run servers
  servers.each do |server|
    RunGetWpUsernameJob.perform_later server
  end
end

run Server.where('project_id = ? ', ARGV[0])
