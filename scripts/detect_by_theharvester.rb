ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

puts "== install theHarvest first"
def run servers
  puts "== servers.count: #{servers.count}"
  servers.each_slice(5) do |sites|

    threads = []
    sites.each do |site|

      threads << Thread.new do

        puts "== checking site: #{site.name}, index: #{site.id}"
        command = "cd /workspace/coding_tools/theHarvester && python3 theHarvester.py -d #{site.name} -b all -p"
        result = `#{command}`
        site.update the_harvester_result: result
        puts "== done, #{site.name}, #{site.id}"
      end
    end
    threads.each {|t| t.join}
    sleep 300

  end
end

run Server.where('the_harvester_result is null').order('level asc')
