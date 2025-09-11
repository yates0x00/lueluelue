class RunEholeJob < ApplicationJob
  queue_as :default

  def perform options
    server = options[:server]
    https_result = ''
    http_result = ''
    # try https
    #
    # [ http://jw.qut.edu.cn/info/1004/2786.htm |  | ********* | 200 | 85731 | 我校首获山东省本科教学改革研究项目重大专项-青岛理工大学教务处 ]
    command = "ehole finger -u https://#{server.name}"
    https_result = `#{command}`.match(/\[.*\]/).to_s
    puts "-- https_result: #{https_result}"

    response_code = https_result.split('|')[3]

    if https_result.present? && https_result.to_i < 400
      web_server = https_result.split('|')[2]
      title = https_result.split('|')[5]
      server.update title: title, web_server: web_server, ehole_result: https_result
    else
      # if blank, then http
      command = "ehole finger -u http://#{server.name}"
      http_result = `#{command}`.match(/\[.*\]/).to_s
      puts "-- http_result: #{http_result}"
      web_server = http_result.split('|')[2]
      title = http_result.split('|')[5]
      server.update title: title, web_server: web_server, ehole_result: "https seems not work" + https_result + http_result
    end
    server.update is_detected_by_ehole: true

  end
end
