ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

require 'csv'


puts "== install wappalyzer from: https://github.com/wappalyzer/wappalyzer"

WAPPALYZER = "node /workspace/coding_tools/wappalyzer/src/drivers/npm/cli.js"

def run_single_thread url, server
  command = "#{WAPPALYZER} https://#{url}"
  result = `#{command}`
  puts "== result: #{result.inspect}"
  puts "== result.urls: #{JSON.parse(result)['urls'].inspect}"
  key = JSON.parse(result)['urls'].keys[0]
  puts "== key is: #{key}"
  if JSON.parse(result)['urls'][key]['status'] < 400
    server.update wappalyzer_result: result
  else
    command = "#{WAPPALYZER} http://#{url}"
    result = `#{command}`
    server.update wappalyzer_result: "https is not available, <br/>" + result
  end
  server.update is_detected_by_wappalyzer: true
end

def run servers
  puts "== servers.count: #{servers.count}"
  servers.each_slice(10) do |servers|
    threads = []
    servers.each do |server|
      threads << Thread.new do
        puts "== site: #{server.name}, id: #{server.id}, now: #{Time.now}"
        run_single_thread server.name, server
      end
    end
    threads.each {|t| t.join }
    sleep 30
  end
end

servers = Server.where("project_id = 2 and is_detected_by_wappalyzer = ?", false).order('id desc')
run servers
