require 'httparty'
require 'nokogiri'

exchanges = %w[ /exchanges/binance/
/exchanges/bybit/
/exchanges/coinbase-exchange/
/exchanges/upbit/
/exchanges/okx/
/exchanges/bitget/
/exchanges/gate/
/exchanges/mexc/
/exchanges/kucoin/
/exchanges/htx/
/exchanges/crypto-com-exchange/
/exchanges/bitfinex/
/exchanges/bingx/
/exchanges/kraken/
/exchanges/binance-tr/
/exchanges/bitmart/
/exchanges/lbank/
/exchanges/bitstamp/
/exchanges/bithumb/
/exchanges/xt/
/exchanges/tokocrypto/
/exchanges/bitflyer/
/exchanges/binance-us/
/exchanges/gemini/
/exchanges/deepcoin/
/exchanges/biconomy/
/exchanges/kcex/
/exchanges/toobit/
/exchanges/pionex/
/exchanges/uzx/
/exchanges/coinw/
/exchanges/digifinex/
/exchanges/probit-exchange/
/exchanges/btcc/
/exchanges/weex/
/exchanges/ascendex/
/exchanges/binance-th/
/exchanges/pb/
/exchanges/tapbit/
/exchanges/zoomex/
/exchanges/bvox/
/exchanges/fameex/
/exchanges/blofin/
/exchanges/ourbit/
/exchanges/hibt/
/exchanges/coinup-io/
/exchanges/bifinance-exchange/
/exchanges/bitvavo/
/exchanges/azbit/
/exchanges/coincheck/
/exchanges/orangex/
/exchanges/backpack-exchange/
/exchanges/whitebit/
/exchanges/coinstore/
/exchanges/voox-exchange/
/exchanges/hashkey-global/
/exchanges/zaif/
/exchanges/poloniex/
/exchanges/latoken/
/exchanges/safex-exchange/
/exchanges/bitrue/
/exchanges/phemex/
/exchanges/jucom/
/exchanges/coinex/
/exchanges/bitunix/
/exchanges/coinone/
/exchanges/bitkub/
/exchanges/bitso/
/exchanges/dex-trade/
/exchanges/bitbank/
/exchanges/echobit/
/exchanges/btse/
/exchanges/bigone/
/exchanges/luno/
/exchanges/hotcoin-global/
/exchanges/hashkey-exchange/
/exchanges/btcturk-kripto/
/exchanges/bitradex/
/exchanges/bitmex/
/exchanges/fastex/
/exchanges/pointpay/
/exchanges/c-patex/
/exchanges/bittap/
/exchanges/bitme/
/exchanges/exmo/
/exchanges/korbit/
/exchanges/max-exchange/
/exchanges/cex-io/
/exchanges/mercado-bitcoin/
/exchanges/bitopro/
/exchanges/okcoin-japan/
/exchanges/woox/
/exchanges/paribu/
/exchanges/koinbay/
/exchanges/indodax/
/exchanges/bittrade/
/exchanges/cube-exchange/
/exchanges/secondbtc/
/exchanges/indoex/
/exchanges/bullish/
/exchanges/rekeningku-com/
/exchanges/hitbtc/
/exchanges/foxbit/
/exchanges/btc-markets/
/exchanges/independent-reserve/
/exchanges/tothemoon/
/exchanges/bitmarkets/
/exchanges/coins-pro/
/exchanges/trubit-exchange/
/exchanges/koinbx/
/exchanges/coinmate/
/exchanges/bitcoin-com-exchange/
/exchanges/bitdelta/
/exchanges/coinjar/
/exchanges/wisebitcoin/
/exchanges/megabit/
/exchanges/websea/
/exchanges/bitexen/
/exchanges/coinmetro/
/exchanges/flipster/
/exchanges/icrypex/
/exchanges/bitspay/
/exchanges/buda/
/exchanges/lmax-digital/
/exchanges/exmo-me/
/exchanges/qmall/
/exchanges/coinzoom/
/exchanges/btc-alpha/
/exchanges/bitstorage/
/exchanges/bitexlive/
/exchanges/bit-com/
/exchanges/gopax/
/exchanges/paymium/
/exchanges/nonkyc/
/exchanges/ripio/
/exchanges/coinflare/
/exchanges/btcbox/
/exchanges/valr/
/exchanges/bilaxy/
/exchanges/bydfi/
/exchanges/coindcx/
/exchanges/onus-pro/
/exchanges/novadax/
/exchanges/coincatch/
/exchanges/bitcastle/
/exchanges/zebpay/
/exchanges/superex/
/exchanges/altcoin-trader/
/exchanges/giottus/
/exchanges/changelly-pro/
/exchanges/niza-global/
/exchanges/digitalexchange-id/
/exchanges/remitano/
/exchanges/lcx-exchange/
/exchanges/bitop/
/exchanges/swft-octopus-trade/
/exchanges/vindax/
/exchanges/mandala/
/exchanges/4e/
/exchanges/coinchief/
/exchanges/bitbns/
/exchanges/emirex/
/exchanges/spirex/
/exchanges/aia-exchange/
/exchanges/yobit/
/exchanges/cryptonex/
/exchanges/xex/
/exchanges/localtrade/
/exchanges/zke/
/exchanges/bankcex/
/exchanges/bibox/
/exchanges/catex/
/exchanges/bitcoiva/
/exchanges/hkd/
/exchanges/salavi-exchange/
/exchanges/coincorner/
/exchanges/coinbase-international-exchange/
/exchanges/gleec-btc/
/exchanges/crypton-exchange/
/exchanges/ekbit/
/exchanges/grovex/
/exchanges/cryptomus/
/exchanges/bitbabyexchange/
/exchanges/darkex-exchange/
/exchanges/blockfin/
/exchanges/dzengi-com/
/exchanges/aivora-exchange/
/exchanges/changenow/
/exchanges/arkham/
/exchanges/ibit-global/
/exchanges/zonda/
/exchanges/triv/
/exchanges/all-inx/
/exchanges/bitkan/
/exchanges/novaex/
/exchanges/kanga-exchange/
/exchanges/millionero/
/exchanges/xbo-com/
/exchanges/blynex/
/exchanges/levex/
/exchanges/coinp/
/exchanges/bitazza/
/exchanges/astralx/
/exchanges/kinesis-money/
/exchanges/bitlo/
/exchanges/gaiaex/
/exchanges/coinlocally/
/exchanges/cofinex/
/exchanges/zedcex-exchange/
/exchanges/biking/
/exchanges/nexdax/
/exchanges/easicoin/
/exchanges/gems-trade/
/exchanges/tgex/
/exchanges/xxkk/
/exchanges/byex/
/exchanges/tokenize-xchange/
/exchanges/yex/
/exchanges/coinspace/
/exchanges/young-platform/
/exchanges/zedxion-exchange/
/exchanges/koinpark/
/exchanges/criptoswaps/
/exchanges/coincola/
/exchanges/mars-exchange/
/exchanges/metal-x/
/exchanges/unocoin/
/exchanges/bit-team/
/exchanges/timex/
/exchanges/tokpie/
/exchanges/digitra-com/
/exchanges/safetrade/
/exchanges/nivex/
/exchanges/polyx/
/exchanges/coinut/
/exchanges/ceex-exchange/
/exchanges/bluebit/
/exchanges/bitonic/
/exchanges/bithash/
/exchanges/coinlion/
/exchanges/ndax/
/exchanges/b2z-exchange/
/exchanges/stakecube/
/exchanges/serenity/
/exchanges/bcex-korea/
/exchanges/freiexchange/
/exchanges/figure-markets/
/exchanges/bittylicious/
/exchanges/klever-exchange/
/exchanges/foblgate/
/exchanges/namebase/
/exchanges/listadao/
]




def get_exchange_url exchange
  full_url = "https://coinmarketcap.com#{exchange}"
  
  begin
    response = HTTParty.get(full_url, 
      headers: {
        'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
      },
      timeout: 10
    )
    
    # 使用 Nokogiri 解析 HTML
    doc = Nokogiri::HTML(response.body)
    
    # 查找包含网站链接的元素
    # 通常在 class 包含 "sc-" 的 div 中，查找 a 标签
    website_link = doc.css('a[rel="nofollow noopener"][target="_blank"]').find do |link|
      href = link['href']
      href && href.start_with?('http') && !href.include?('twitter.com') && !href.include?('fees')
    end
    
    website_url = website_link['href']
    puts website_link
  rescue => e
    puts "#{exchange}: Error - #{e.message}"
  end
end

exchanges.each do |exchange|
  get_exchange_url exchange
end