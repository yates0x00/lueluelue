require 'httparty'
require 'nokogiri'
require 'json'

def get_json skip

  command = %Q{ curl -s 'https://api.coin-stats.com/v2/exchanges/list?limit=100&skip=#{skip}' \
    --compressed \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2' \
    -H 'Accept-Encoding: gzip, deflate, br, zstd' \
    -H 'platform: web' \
    -H 'x-app-appearance: dark' \
    -H 'x-language-code: en' \
    -H 'Origin: https://coinstats.app' \
    -H 'Connection: keep-alive' \
    -H 'Referer: https://coinstats.app/' \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Site: cross-site'
  }
  json_result = `#{command}`
  JSON.parse(json_result)['exchanges'].each do |element|
    puts element['url']
  end

end

[0, 100, 200].each do |skip|
  get_json skip
end
