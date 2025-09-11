ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

Server.where('created_at > ?', '2024-06-25').each do |server|
  next if server.wafwoof_result.blank?
  if server.wafwoof_result.include? "No WAF detected"
    server.is_confirmed_not_behind_waf = true
  elsif server.wafwoof_result.include? "is behind"
    server.is_confirmed_behind_waf = true
  else

  end

  server.save!
end

