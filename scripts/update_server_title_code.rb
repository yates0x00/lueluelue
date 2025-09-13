ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

Server.all.each do |server|
  parts = server.ehole_result.split('|')

  response_code = parts[3] || "未知状态码"
  title = parts[5] || "无响应信息"
  server.update title: title, response_code: response_code
end


