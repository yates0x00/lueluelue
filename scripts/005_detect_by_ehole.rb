ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

require 'csv'


puts "== install ehole from: https://github.com/EdgeSecurityTeam/EHole"


def run servers
  servers.each do |server|
    RunEholeJob.set(priority: 5).perform_later server: server
  end
end

#run Server.where('project_id = 2 and is_detected_by_ehole = 0').order('level asc')
run Server.where('project_id = ? and is_detected_by_ehole = ?', ARGV[0], true).order('level asc')
