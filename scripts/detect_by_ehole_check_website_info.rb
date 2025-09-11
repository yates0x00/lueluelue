ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

require 'csv'


puts "== install ehole from: https://github.com/EdgeSecurityTeam/EHole"


def run servers
  servers.each_slice(20) do |sites|

    threads = []
    sites.each do |site|

      threads << Thread.new do

        index = servers.index(site)
        puts "== checking site: #{site.name}, index: #{index}"
        https_result = ''
        http_result = ''
        # try https
        #
        # [ http://jw.qut.edu.cn/info/1004/2786.htm |  | ********* | 200 | 85731 | 我校首获山东省本科教学改革研究项目重大专项-青岛理工大学教务处 ]
        command = "ehole finger -u https://#{site.name}"
        https_result = `#{command}`.match(/\[.*\]/).to_s
        puts "-- https_result: #{https_result}"

        response_code = https_result.split('|')[3]

        if https_result.present? && https_result.to_i < 400
          web_server = https_result.split('|')[2]
          title = https_result.split('|')[5]
          site.update title: title, web_server: web_server, ehole_result: https_result
        else
          # if blank, then http
          command = "ehole finger -u http://#{site.name}"
          http_result = `#{command}`.match(/\[.*\]/).to_s
          puts "-- http_result: #{http_result}"
          web_server = http_result.split('|')[2]
          title = http_result.split('|')[5]
          site.update title: title, web_server: web_server, ehole_result: "https seems not work" + https_result + http_result
        end
        site.update is_detected_by_ehole: true
      end
    end
    threads.each {|t| t.join}
    sleep 10

  end
end

#run Server.where('project_id = 2 and is_detected_by_ehole = 0').order('level asc')
run Server.where('project_id = 31 and is_detected_by_ehole = ?', false).order('level asc')
