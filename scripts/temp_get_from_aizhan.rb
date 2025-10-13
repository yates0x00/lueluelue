ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'
require 'nokogiri'


def get_domains_from_one_page page, score
  command = "curl 'https://bigdata.aizhan.com/baidu/rank/?type=1&cateid=0&filters%5Bplatform%5D=pc&filters%5Bbd%5D=1&filters%5Bbr%5D=#{score}&page=#{page}' \
  --compressed \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
  -H 'Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Referer: https://bigdata.aizhan.com/baidu/rank/?type=1&cateid=0&filters%5Bplatform%5D=pc&filters%5Bbd%5D=1&filters%5Bbr%5D=4' \
  -H 'Connection: keep-alive' \
  -H 'Cookie: _c_WBKFRo=J1aNRtJPH5N30FGFSROtqokXkgKy9BSSTKZdywL3; Hm_lvt_b37205f3f69d03924c5447d020c09192=1758759645,1759660283; Hm_lvt_a55831dc904af4622d8829a52718eb0d=1758759682,1759660273; allSites=zhuanlan.zhihu.com%7Cwww.cailiao.com%7Cwww.xp.cn%7Ctra.oversea.cnki.net%2C0; PHPSESSID=rq0gvkt853d0d1q9q60tuf53p0; _csrf=a8a3406c62741f974365553c0c10f744c232be67d92c9e3431f18c53dad77568a%3A2%3A%7Bi%3A0%3Bs%3A5%3A%22_csrf%22%3Bi%3A1%3Bs%3A32%3A%22sLUo84AOFOndMAqUGdNP0HJqMhCDS-zR%22%3B%7D; Hm_lpvt_a55831dc904af4622d8829a52718eb0d=1759660354; HMACCOUNT=580DB81CB62D3DFF; Hm_lpvt_b37205f3f69d03924c5447d020c09192=1759660354; HMACCOUNT=580DB81CB62D3DFF; userId=1538190; userName=huoshan594166%40gmail.com; userGroup=1; userSecure=9lT9hbN7DdoKCU53T%2Fd3cP4sZkeUO7AaKOmLemgAajzjnXIiYEgi3mei7h8p%2FmtUSZBWzoYAhCOXEr6xCsOwTk6vxhRBOIm%2BFuKi2K9zrc%2BGsxUPblflsu0Wfrw5%2F%2B2tHo9YfkC3MhNvkn0jp3FfSA%3D%3D' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Priority: u=0, i'"
  response = `#{command}`
  puts "=== response: #{response}"
  doc = Nokogiri::HTML response
  puts "=== sleep 20 s"

  result = []
  doc.css('.table-rank tbody td.site a').each do  |a|
    result << a['href'].sub("//www.aizhan.com/cha/",'').sub('/', '')
  end
  puts "-- result: #{result.inspect}"

  sleep 20
  return result
end


final_result = []

(1..100).each do |page|
  final_result += get_domains_from_one_page page, 5
end

(1..20).each do |page|
  final_result += get_domains_from_one_page page, 6
end

(1..17).each do |page|
  final_result += get_domains_from_one_page page, 7
end

(1..4).each do |page|
  final_result += get_domains_from_one_page page, 8
end

(1..1).each do |page|
  final_result += get_domains_from_one_page page, 9
end

(1..1).each do |page|
  final_result += get_domains_from_one_page page, 10
end

final_result.each do |site|
  puts "=============== final result:"
  puts site
end
