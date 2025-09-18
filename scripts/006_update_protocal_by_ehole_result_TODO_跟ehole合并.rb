ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

Server.all.each do |server|
  protocal = nil
  if server.ehole_result.present?
    if server.ehole_result.include?("https:")
      protocal = 'https'
    elsif server.ehole_result.include?("http:")
      protocal = 'http'
    end
    server.protocal = protocal
    server.save!
  end
end

