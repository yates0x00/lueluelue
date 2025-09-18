ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

Ip.all.each do |ip_entity|
  command = "curl https://api.iplocation.net/?ip=#{ip_entity.ip}"
  response = `#{command}`
  puts "== ip: #{ip_entity.ip}, location: #{JSON.parse(response)['country_name']}"

  ip_entity.update location: JSON.parse(response)['country_name']
  sleep 0.3
end
