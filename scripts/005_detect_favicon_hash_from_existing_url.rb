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

puts "== used to check if icon hash is correct"
puts FaviconTool.get_favicon_mmh3_hash ARGV[0]

