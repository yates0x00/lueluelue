ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

require 'csv'

def get_ip_by_domains servers
  servers.each_slice(20) do |servers_in_20|

    threads = []
    servers_in_20.each do |server|
      threads << Thread.new do
        command = "dig +short #{server.name}"
        dig_result = `#{command}`

        Rails.logger.info "== command: #{command}, result: #{dig_result}"

        server.update is_detected_by_dig: true, dig_result: dig_result
      end
    end
    threads.each {|t| t.join}

    sleep 5
  end
end

servers = Server.where('project_id = 3')
get_ip_by_domains servers
