ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

require 'csv'

# 把IP跟server做个映射，查看具体的ip 与server, 重要。

ips = []
Server.where('project_id = ?', ARGV[0]).find_each do |server|
  next if server.dig_result.blank?
  server.dig_result.scan(/\d+\.\d+\.\d+\.\d+/).each do |ip|
    ips << ip
    ip_record = Ip.find_by_ip ip
    if ip_record.blank?
      ip_record = Ip.create ip: ip
    end

    IpMapping.create ip_id: ip_record.id, server_id: server.id
  end
end


