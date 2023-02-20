ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def run servers, is_https = true
  puts "=servers to run:#{servers.count}"

  servers.each_slice(10) do |servers_in_20|

    threads = []
    servers_in_20.each do |server|
      threads << Thread.new do
        name = server.name
        if is_https
          command = "nuclei -u https://#{name} -se nuclei_result_#{name} -as"
          result = `#{command}`
          if result.blank?
            result = 'not found'
          end
          Rails.logger.info "== command: #{command}, raw result: #{result}"
          server.update nuclei_https_result: result
        else
          command = "nuclei -u http://#{name} -se nuclei_result_#{name} -as"
          result = `#{command}`
          if result.blank?
            result = 'not found'
          end
          Rails.logger.info "== command: #{command}, raw result: #{result}"
          server.update nuclei_http_result: result
        end
      end
    end

    threads.each {|t| t.join}
    sleep 120
  end
end

#run Server.where("name like '%beiersdorf%'"), true
#run Server.where("name like '%beiersdorf%'"), false

run Server.where("name not like '%beiersdorf%'"), true
run Server.where("name not like '%beiersdorf%'"), false

