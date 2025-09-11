ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

Server.all.each do |server|
  server.is_detected_by_wafwoof = server.wafwoof_result.present?
  server.is_detected_by_dig = server.dig_result.present?
  server.is_detected_by_observer_ward = server.observer_ward_result.present?
  server.is_detected_by_ehole = server.ehole_result.present?
  server.is_detected_by_wappalyzer = server.wappalyzer_result.present?
  server.is_detected_by_the_harvester = server.the_harvester_result.present?
  server.is_detected_by_nuclei_http = server.nuclei_http_result.present?
  server.is_detected_by_nuclei_https = server.nuclei_https_result.present?
  server.is_detected_by_nuclei_manual = server.nuclei_manual_result.present?
  server.save!
end

