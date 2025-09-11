ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'


def get_max_severity string
  return if string.blank?
  json = JSON.parse string rescue []
  rules = json['runs']['tool']['driver']['rules'] rescue nil
  return if rules.blank?
  result = rules.map { |rule| rule['properties']['security-severity'] }.sort.last
  puts "== checking string: #{string}, result: #{result}"
  return result
end

Server.all.where('nuclei_https_result is not null').each do |server|
  puts "== checking: server: #{server.id}"
  max_severity = nil
  max_severity = get_max_severity server.nuclei_https_result
  max_severity = get_max_severity server.nuclei_http_result if max_severity.blank?
  max_severity = get_max_severity server.nuclei_manual_result if max_severity.blank?

  server.update max_security_severity: max_severity if max_severity.present?
end

puts "== done"

