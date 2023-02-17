ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

require 'csv'

ips = []
Server.all.each do |server|
  server.pure_ip.split(',').each do |ip|
    ips << ip
    ip_record = Ip.find_by_ip ip
    if ip_record.blank?
      ip_record = Ip.create ip: ip
    end

    IpMapping.create ip_id: ip_record.id, server_id: server.id
  end
end


