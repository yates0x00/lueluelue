
ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def run servers
  servers.each do |server|
    command = "#{ENV['COMMAND_OF_WHATWEB']} #{server.name}"
    RunJob.perform_later command: command, entity: ip, result_column: "whatweb_result", is_detected_by_column: :is_detected_by_whatweb
  end
end

