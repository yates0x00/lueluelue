ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'
require 'csv'
require 'json'


@domains = []

File.read('aizhan_all.txt').each_line do |line|
  command = "npx tldts '#{line}'"
  result = `#{command}`
  json = JSON.parse result


  #{
  #    "domain": "writethedocs.org",
  #    "domainWithoutSuffix": "writethedocs",
  #    "hostname": "www.writethedocs.org",
  #    "isIcann": true,
  #    "isIp": false,
  #    "isPrivate": false,
  #    "publicSuffix": "org",
  #    "subdomain": "www"
  #}

  puts json['domain']
  @domains << json['domain']
end

File.open('all_aizhan_domain_final.txt', 'w') do |file|
  @domains.each do |domain|
    file.puts domain
  end
end
