ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def run servers
  Rails.logger.info "== servers: #{servers.size}"
  servers.each do |server|
    RunGobusterJob.perform_later(server)
  end
end

# 需要找到真实IP 对应的网址, 200存活的
run Server.where('response_code != "" and project_id = ? and is_detected_by_dirsearch = 0', ARGV[0] )
