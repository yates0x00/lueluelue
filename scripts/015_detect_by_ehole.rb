ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'
require 'csv'

def run servers
  servers.each do |server|
    RunEholeJob.perform_later server: server
  end
end

run Server.where('project_id = ?', ARGV[0] )
