ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'
require 'csv'

def run servers
  servers.each do |server|
    RunJob.perform_later command: command, result_column: 'favicon_hash_of_fofa',
      is_detected_by_column: 'is_detected_by_wafwoof',
      entity: server    
  end
end

runServer.where('project_id = ?', ARGV[0])

