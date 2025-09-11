ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'
require 'csv'

# this file is used for create servers from ip/domain list

COMMENT = "from nextcloud.com, from shuize and theharvester"

# put ip, sites here
sites = %w{
95.217.53.233
}.compact.uniq

def get_ip_by_domains sites
  result = []
  sites.each_slice(20) do |sites_in_20|

    threads = []
    sites_in_20.each do |site|
      threads << Thread.new do
        puts "site: #{site}"
        server = Server.where("name = ?", site).first
        if server.blank?
          server = Server.create name: site, comment: COMMENT
        end

        command = "dig +short #{site}"
        dig_result = `#{command}`

        Rails.logger.info "== command: #{command}, result: #{dig_result}"

        server.dig_result = dig_result
        server.save!
      end
    end
    threads.each {|t| t.join}

    sleep 5
  end
end

def get_wafw00f_result_by_domains sites
  sites.each_slice(20) do |sites_in_20|

    threads = []
    sites_in_20.each do |site|
      threads << Thread.new do
        puts "site: #{site}, index: #{sites.index(site)}"
        server = Server.where("name = ?", site).first
        if server.blank?
          server = Server.create name: site
        end

        command = "wafw00f #{site}"
        result = `#{command}`
        Rails.logger.info "== command: #{command}, result: #{result}"

        server.wafwoof_result = result
        server.save!
      end
    end
  end
end

get_ip_by_domains sites
