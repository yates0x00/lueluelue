require 'httparty'
require 'nokogiri'
require 'json'

# https://dncapi.flink1.com/api/v2/exchange/web-exchange?token=&page=1&pagesize=100&sort_type=exrank&asc=1&isinnovation=1&type=all&area=&webp=1
# https://dncapi.flink1.com/api/v2/exchange/web-exchange?token=&page=2&pagesize=100&sort_type=exrank&asc=1&isinnovation=1&type=all&area=&webp=1
#

@ids = []

def get_exchange_id page
  command = %Q{curl 'https://dncapi.flink1.com/api/v2/exchange/web-exchange?token=&page=#{page}&pagesize=100&sort_type=exrank&asc=1&isinnovation=1&type=all&area=&webp=1' \
    --compressed \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2' \
    -H 'Accept-Encoding: gzip, deflate, br, zstd' \
    -H 'Origin: https://www.feixiaohao.com' \
    -H 'Connection: keep-alive' \
    -H 'Referer: https://www.feixiaohao.com/' \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Site: cross-site' \
    -H 'TE: trailers'
  }

  string_result = `#{command}`

  JSON.parse(string_result)['data'].each do |data|
    @ids << data['id']
  end
end

[1,2].each do |page|
  get_exchange_id page
end

puts "===== exchange ids: "
puts @ids

@ids.each do |exchange_id|
  url = "https://www.feixiaohao.com/exchange/#{exchange_id}"
  HTTParty
  begin
    response = HTTParty.get(url,
      headers: {
        'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
      },
      timeout: 10
    )

    # 使用 Nokogiri 解析 HTML
    doc = Nokogiri::HTML(response.body)
    # <div class="card-footer"><div class="action-buttons"><a href="https://accounts.binance.com/register?ref=1059258381" target="_blank">查看官网</a> <a href="/software/binance/" target="_blank" class="">下载地址</a> <!----> <!----></div> <div class="social-links"><a href="https://twitter.com/binance" target="_blank" class="social-icon"><div class="svgIcon-comp"><svg aria-hidden="true" class="svg-icon"><use xlink:href="#icon-ic_platform_twitter"></use></svg></div></a> <a href="https://www.facebook.com/binance" target="_blank" class="social-icon"><div class="svgIcon-comp"><svg aria-hidden="true" class="svg-icon"><use xlink:href="#icon-ic_platform_facebook"></use></svg></div></a> <a href="https://t.me/BinanceChinese
    #
    # " target="_blank" class="social-icon"><div class="svgIcon-comp"><svg aria-hidden="true" class="svg-icon"><use xlink:href="#icon-ic_platform_telegram"></use></svg></div></a> <!----></div></div>
    # TODO: 获得上面的代码片段中的
    # <a href="https://accounts.binance.com/register?ref=1059258381" target="_blank">查看官网</a>
    # 也就是需要这个 <a >标签
    
    # 查找 card-footer 中的 action-buttons 里的第一个 <a> 标签（查看官网链接）
    website_link = doc.css('.card-footer .action-buttons a').first
    
    website_url = website_link['href']
    puts "#{exchange_id}: #{website_url}"
  rescue => e
    puts "#{exchange_id}: Error - #{e.message}"
  end
end
