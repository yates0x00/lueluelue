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

        puts "== #{Time.now}, checking site: #{site.name}, index: #{site.id}"
        command = "cd /workspace/coding_tools/theHarvester && python3 theHarvester.py -d #{site.name} -b all -p"
        result = `#{command}`
        site.update the_harvester_result: result
        puts "== #{Time.now} done, #{site.name}, #{site.id}"
      end
    end
    threads.each {|t| t.join}
    sleep 600

  end
end

#run Server.where('name = ?', 'nextcloud.com').order('level asc')
#run Server.where('name = ?', 'nextcloud.org').order('level asc')
#run Server.where('name like ? and name != ?', "%nextcloud%", 'nextcloud.com').order('level asc')

#run Server.where('name = ?', 'bc.game').order('level asc')
run Server.where('project_id = 31 and is_detected_by_the_harvester = 0 ').order('level asc')
