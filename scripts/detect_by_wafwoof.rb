ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def get_wafw00f_result_by_domains servers
  puts "== servers : #{servers.count} to detect"
  servers.each_slice(20) do |servers_in_20|

    threads = []
    servers_in_20.each do |server|
      threads << Thread.new do
        puts "server: #{server}, index: #{servers.index(server)}"

        command = "wafw00f #{server.name}"
        puts "== command: #{command}"
        result = `#{command}`
        Rails.logger.info "== command: #{command}, result: #{result}"

        server.is_detected_by_wafwoof = true
        server.wafwoof_result = result
        server.save!
      end
    end
    threads.each { |t| t.join }
    sleep 60
  end
end

#get_wafw00f_result_by_domains Server.where('project_id = 2 and is_detected_by_wafwoof = ?', false)
get_wafw00f_result_by_domains Server.where('project_id = 3')
