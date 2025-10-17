#  1. 使用 https://favicone.com/ 这个api 来获得对应的icon 文件
#  例如：GET https://favicone.com/weex.com?json
#  结果为：{
#   "hasIcon": true,
#   "icon": "https://icons.favicone.com/i/www.weex.com/baseasset/favicon.ico",
#   "format": "ico"
# }
#  2. 保存对应的 icon到本地，例如 tmp目录下的icons, 同时保存 上面的icon url 到 server表的 favicon_url 字段中。
#  3. 计算该文件对应的icon_hash . (参考下面的脚本)
#  4. 保存对应的 icon_hash 到 server表的 favicon_hash_of_fofa 字段中。
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'
require 'json'

def run servers
    servers.each do |server|
        begin
            url = "https://favicone.com/#{server.name}?json"
            Rails.logger.info "== url is: #{url}"

            # 发送请求并检查响应状态
            response = HTTParty.get(url, timeout: 30)

            # 检查HTTP响应状态码
            unless response.code == 200
                Rails.logger.error "== HTTP请求失败，状态码: #{response.code}"
                Rails.logger.error "== 响应内容: #{response.body.inspect}"
                next
            end

            Rails.logger.info "== response: #{response.body.inspect}"

            # 检查响应内容是否为空
            if response.body.nil? || response.body.strip.empty?
                Rails.logger.error "== 响应内容为空"
                next
            end

            # 检查响应内容是否为JSON格式
            begin
                json_response = JSON.parse(response.body)
            rescue JSON::ParserError => e
                Rails.logger.error "== JSON解析错误: #{e.message}"
                Rails.logger.error "== 响应内容: #{response.body.inspect}"
                next # 跳过当前服务器，继续处理下一个
            end

            # 检查JSON响应是否包含预期的字段
            unless json_response.is_a?(Hash)
                Rails.logger.error "== 响应不是有效的JSON对象: #{json_response.inspect}"
                next
            end

            if json_response['hasIcon']
                icon_url = json_response['icon']
                server.update(favicon_url: icon_url)
                icon_hash = FaviconTool.get_favicon_mmh3_hash(icon_url)
                server.update(favicon_hash_of_fofa: icon_hash)
            else
                Rails.logger.info "== not found favicon for #{server.name}"
            end
        rescue Net::TimeoutError => e
            Rails.logger.error "== 请求超时: #{e.message}"
            next
        rescue StandardError => e
            Rails.logger.error "== 处理服务器 #{server.name} 时发生错误: #{e.message}"
            Rails.logger.error "== 错误详情: #{e.backtrace.join("\n")}"
            next
        end
    end
end

 run Server.where('level = 1 and project_id = ? and favicon_hash_of_fofa is null', ARGV[0])
# run Server.where('level = 1 and project_id = ? ', ARGV[0])
