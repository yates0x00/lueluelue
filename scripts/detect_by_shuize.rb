ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

puts "== install Shuize first"
def run servers
  puts "== servers.count"
  servers.each_slice(8) do |sites|

    threads = []
    sites.each do |site|

      threads << Thread.new do

        puts "== checking site: #{site.name}, index: #{site.id}"
        result_file = "/workspace/coding_tools/shuize/results/#{site.name}.xlsx"
        touch_command = "touch #{result_file}"
        `#{touch_command}`
        command = "cd /workspace/coding_tools/shuize && python3 ShuiZe.py -d #{site.name} -f #{result_file} --proxy=socks5://192.168.1.105:1092"
        puts "== command: #{command}"
        result = `#{command}`
        puts "done, #{site.name}, #{site.id}, check saved to #{result_file}"
      end
    end
    threads.each {|t| t.join}
    sleep 800
  end
end

#run Server.where('(name not like "%beiersdorf%" and name not like "%nivea%")').order('level asc')
#run Server.where('id >= 9301').order('level asc')
run Server.where('id = 10361').order('level asc')
