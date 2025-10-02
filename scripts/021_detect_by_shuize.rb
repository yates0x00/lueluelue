ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

puts "== please install Shuize first"
def run servers

  servers.each do |server|
    puts "== checking server: #{server.name}, index: #{server.id}"

    result_file = "/workspace/coding_tools/shuize/results/#{server.name}.xlsx"
    touch_command = "touch #{result_file}"
    `#{touch_command}`
    #command = "cd /workspace/coding_tools/shuize && python3 ShuiZe.py -d #{server.name} -f #{result_file} --proxy=socks5://192.168.1.105:1092"
    command = "#{COMMAND_OF_SHUIZE} -d #{server.name} -f #{result_file}"
    puts "== command: #{command}"
    #result = `#{command}`
    #puts "done, #{server.name}, #{server.id}, check saved to #{result_file}"

    RunJob.perform_later command: command
  end

end

#run Server.where('(name not like "%beiersdorf%" and name not like "%nivea%")').order('level asc')
#run Server.where('id >= 9301').order('level asc')
run Server.where('project_id >= 7').order('level asc')
