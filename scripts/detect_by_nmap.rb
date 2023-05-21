ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

TOP_PORTS = 500
Ip.where('nmap_result is null').each_slice(20) do |ips|

  threads = []

  ips.each do |ip|
    threads << Thread.new do
      command = "nmap -sT -sV --top-ports #{TOP_PORTS} --open -A #{ip.ip}"
      puts "== command: #{command}, now: #{Time.now}"
      result = `#{command}`
      ip.update nmap_result: result
      puts "== done, now: #{Time.now}, command: #{command}"
    end
  end

  threads.each {|t| t.join}

  sleep 300
end
