ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

files = Dir.glob('./nuclei_result_nextcloud/**/*').select {|e| File.file? e}

files.each do |f|
  puts "== reading : #{f}"
  #domain = f.gsub("./nuclei_result_nextcloud/nuclei_c_class_ip_result_", '')
  domain = f.gsub("./nuclei_result_nextcloud/nuclei_result_", '')

  server = Server.where(name: domain).last
  if server.blank?
    puts "=== server is blank: #{domain}, next"
    next
  end
  server.update nuclei_https_result: File.read(f), is_detected_by_nuclei_https: true
end
