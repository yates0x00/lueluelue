ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def run servers, is_https = true

  servers.each do |server|
    puts "== checking server: #{server.name}, index: #{server.id}"

    name = server.name
    attribute = ''

    if is_https == "c_class"
      command = "nuclei -u #{name} -se nuclei_c_class_ip_result_#{name} -as"
      attribute = 'nuclei_manual_result'
      #result = `#{command}`
      #if result.blank?
      #  result = 'not found'
      #end
      #Rails.logger.info "== command: #{command}, raw result: #{result}"
      #server.update nuclei_manual_result: result

    elsif is_https
      command = "nuclei -u https://#{name} -se nuclei_result_#{name} -as"
      attribute = 'nuclei_https_result'
      #result = `#{command}`
      #if result.blank?
      #  result = 'not found'
      #end
      #Rails.logger.info "== command: #{command}, raw result: #{result}"
      #server.update nuclei_https_result: result
    else
      command = "nuclei -u http://#{name} -se nuclei_result_#{name} -as"
      attribute = 'nuclei_http_result'
      #result = `#{command}`
      #if result.blank?
      #  result = 'not found'
      #end
      #Rails.logger.info "== command: #{command}, raw result: #{result}"
      #server.update nuclei_http_result: result
    end
    RunJob.perform_later command: command, entity: server, result_column: 'nuclei_https_result',
      is_detected_by_column: 'is_detected_by_nuclei_https'
  end

end

#run Server.where("name like '%beiersdorf%'"), true
#run Server.where("name like '%beiersdorf%'"), false

#run Server.where("project_id = 2 and is_detected_by_nuclei_https = 0 "), "c_class"
#run Server.where("project_id = 2 and is_detected_by_nuclei_https = 0 "), true
run Server.where("project_id >= 7")

