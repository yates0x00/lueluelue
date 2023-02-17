ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def get_wafw00f_result_by_domains ips
  ips.each_slice(10) do |ips_in_20|

    threads = []
    ips_in_20.each do |ip|
      threads << Thread.new do
        puts "ip: #{ip}, index: #{ips.index(ip)}"

        command = "wafw00f #{ip}"
        result = `#{command}`
        Rails.logger.info "== command: #{command}, raw result: #{result}"

        servers = Server.where("pure_ip like '%#{ip}%'")

        result = result.split("Generic Detection results:").last.split("Number of requests").first.gsub("\n", "")

        puts "== servers.count: #{servers.count}"
        servers.all.each do |server|
          server.wafwoof_result = result
          server.save!
        end
      end
    end

    threads.each {|t| t.join}
    sleep 20
  end
end

all_ips = []
#Server.all.each do |site|
Server.where('wafwoof_result is null').each do |site|
  site.pure_ip.split(',').each do |ip|
    all_ips << ip
  end
end

all_ips = all_ips.uniq

puts "== ips to detect: #{all_ips.size}"

get_wafw00f_result_by_domains all_ips

