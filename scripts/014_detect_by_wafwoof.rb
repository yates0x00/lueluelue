#ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def get_wafw00f_result_by_domains servers

  servers.each do |server|

    command = "#{ENV['COMMAND_OF_WAFW00F']} #{server.name}"

    RunJob.perform_later command: command, result_column: 'wafwoof_result',
      is_detected_by_column: 'is_detected_by_wafwoof',
      entity: server
  end
end

#get_wafw00f_result_by_domains Server.where('project_id = 2 and is_detected_by_wafwoof = ?', false)
#get_wafw00f_result_by_domains Server.where('project_id = 5 and is_detected_by_wafwoof = ? and level <= 4', false)

get_wafw00f_result_by_domains Server.where('project_id = ?', ARGV[0])
# get_wafw00f_result_by_domains Server.where('created_at > ?', '2024-06-25')
