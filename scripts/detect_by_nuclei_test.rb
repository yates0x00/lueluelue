ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def run servers, is_https = true

  servers.each do |server|
    Rails.logger.info "== checking server: #{server.name}, index: #{server.id}"

    command = "nuclei -u siwei.me -se nuclei_result_siwei.me -as"
    command = '/home/siwei/.asdf/shims/nuclei -u siwei.me -nc -se nuclei_result_siwei.me -as'

    RunJob.perform_later command: command, entity: server, result_column: 'nuclei_https_result',
      is_detected_by_column: 'is_detected_by_nuclei_https'
  end

end

#run Server.where("name like '%beiersdorf%'"), true
#run Server.where("name like '%beiersdorf%'"), false

#run Server.where("project_id = 2 and is_detected_by_nuclei_https = 0 "), "c_class"
#run Server.where("project_id = 2 and is_detected_by_nuclei_https = 0 "), true
run Server.where("project_id >= 7").limit(1)

