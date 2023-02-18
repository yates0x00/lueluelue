ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

puts "== install theHarvest first"
def run servers
  puts "== servers.count"
  servers.each_slice(20) do |sites|

    threads = []
    sites.each do |site|

      threads << Thread.new do

        index = servers.index(site)
        puts "== checking site: #{site.name}, index: #{index}"
        https_result = ''
        http_result = ''

        command = "finger -u https://#{site.name}"
        https_result = `#{command}`.match(/\[.*\]/).to_s
        puts "-- https_result: #{https_result}"

      end
    end
    threads.each {|t| t.join}
    sleep 10

  end
end

run Server.where('name like "%beiersdorf%" or name like "%nivea%"').order('level asc')
