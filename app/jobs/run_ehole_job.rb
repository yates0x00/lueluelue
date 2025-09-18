# encoding: utf-8
class RunEholeJob < ApplicationJob
  queue_as :default

  def perform options
    server = options[:server]
    https_result = ''
    http_result = ''
    # try https
    #
    # [ http://jw.qut.edu.cn/info/1004/2786.htm |  | ********* | 200 | 85731 | 我校首获山东省本科教学改革研究项目重大专项-青岛理工大学教务处 ]
    command = "/opt/app/EHole/ehole finger -u https://#{server.name}"
    https_result = `#{command}`.match(/\[.*\]/).to_s
    puts "-- https_result: #{https_result}"

    parts = https_result.split('|')
    response_code = parts[3]

    if https_result.present? && https_result.to_i < 400
      web_server = parts[2]
      response_code = parts[3] || "未知状态码"
      title = parts[5] || "无响应信息"
      server.update title: title, web_server: web_server, ehole_result: https_result,
        response_code: response_code, protocal: 'https'
    else
      # if blank, then http
      command = "/opt/app/EHole/ehole finger -u http://#{server.name}"
      http_result = `#{command}`.match(/\[.*\]/).to_s
      puts "-- http_result: #{http_result}"
      parts = http_result.split('|')

      web_server = parts[2]
      response_code = parts[3] || "未知状态码"
      title = parts[5] || "无响应信息"
      server.update title: title, web_server: web_server, ehole_result: "https seems not work" + https_result + http_result,
        response_code: response_code, protocal: 'http'
    end
    server.update is_detected_by_ehole: true

  end
end
