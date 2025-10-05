ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'

def run servers
  servers.each do |server|
    command = "favihunter -u #{server.domain_protocol}://#{server.name}"
    RunJob.perform_later command: command, result_column: 'favicon_hash_of_fofa_result',
      is_detected_by_column: 'is_detected_by_favihunter',
      entity: server
  end
end

run Server.where('project_id = ? and level=1', ARGV[0])

