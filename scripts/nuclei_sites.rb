ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

Server.all.each do |server|
  server.pure_ip = server.dig_result.scan(/\d+\.\d+\.\d+\.\d+/).join(',')
  server.save!
end

