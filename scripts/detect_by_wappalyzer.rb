ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

require 'csv'


puts "== install wappalyzer from: https://github.com/wappalyzer/wappalyzer"

WAPPALYZER = "node /workspace2/coding_tools/wappalyzer/src/drivers/npm/cli.js"

def run url, server
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
end

all_servers = Server.where("wappalyzer_result is null").order('id desc')
puts "== all_servers.count: #{all_servers.count}"
all_servers.each_slice(10) do |servers|
  threads = []
  servers.each do |server|
    threads << Thread.new do
      puts "== site: #{server.name}, id: #{server.id}, now: #{Time.now}"
      run server.name, server
    end
  end
  threads.each {|t| t.join }
  sleep 30
end
