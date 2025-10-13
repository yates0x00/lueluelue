require 'net/http'
require 'uri'
require 'base64'
require 'murmurhash3'

def get_favicon_mmh3_hash(url)
  begin
    # 解析URL
    uri = URI.parse(url)

    # 处理可能的路径为空问题
    uri.path = '/' if uri.path.empty?

    # 发送请求获取favicon内容，添加超时设置和请求头
    response = Net::HTTP.start(uri.host, uri.port,
                              use_ssl: uri.scheme == 'https',
                              open_timeout: 10,
                              read_timeout: 10) do |http|
      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36'
      http.request(request)
    end

    # 检查请求是否成功
    unless response.is_a?(Net::HTTPSuccess)
      return "请求错误: 状态码 #{response.code}"
    end

    # 对内容进行base64编码
    base64_encoded = Base64.strict_encode64(response.body)

    # 计算MurmurHash3哈希值（32位带符号）
    mmh3_hash = MurmurHash3::V32.str_hash(base64_encoded, 0)
    # 转换为带符号整数（与原Python版本保持一致）
    mmh3_hash = mmh3_hash - 2**32 if mmh3_hash >= 2**31

    return "icon_hash=#{mmh3_hash}"
  rescue URI::InvalidURIError
    return "错误: 无效的URL"
  rescue => e
    return "处理错误: #{e.message}"
  end
end

# 命令行参数处理
if ARGV.size != 1
  puts "用法: ruby get_favicon_hash_for_fofa.rb <favicon_url>"
  exit 1
end

favicon_url = ARGV[0]
result = get_favicon_mmh3_hash(favicon_url)
puts result

