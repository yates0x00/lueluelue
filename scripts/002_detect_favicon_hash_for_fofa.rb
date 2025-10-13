ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'

puts "== 运行这个，再运行 search from fofa (等待5秒）"
sleep 5
puts "== make sure only run 1 delayed job daemon, otherwise will failed , because all temp favicon will be over written"

def run servers
  servers.each do |server|
    command = "favihunter -u #{server.domain_protocol}://#{server.name}"
    RunJob.perform_later command: command, result_column: 'favicon_hash_of_fofa_result',
      is_detected_by_column: 'is_detected_by_favihunter',
      entity: server
  end
end

run Server.where('project_id = ? and level=1', ARGV[0])

