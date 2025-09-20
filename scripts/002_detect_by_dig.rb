#ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

require 'rails'
require 'rubygems'
require 'httparty'

require 'csv'

def run_dig servers
  servers.each do |server|
    RunDigJob.perform_later(server)
  end
end

servers = Server.where('project_id = ?', ARGV[0])
puts "== servers to detect: #{servers.count}"
run_dig servers
