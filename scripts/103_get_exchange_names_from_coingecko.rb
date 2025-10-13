require 'httparty'
require 'nokogiri'
require 'json'
#
#  使用这个JS，从 https://www.coingecko.com/zh/exchanges?page=2 中，运行，即可获得链接
#
# const exchangeLinks = document.querySelectorAll('a[href^="/zh/exchanges/"]');
#const exchangePaths = [];
#exchangeLinks.forEach(link => {
#  const href = link.getAttribute('href');
#  // 确保链接以 /zh/exchanges/ 开头并且不是只有 /zh/exchanges/
#  if (href.startsWith('/zh/exchanges/') && href.length > '/zh/exchanges/'.length) {
#    // 去掉开头的 "/"
#    const path = href.substring(1);
#    exchangePaths.push(path);
#  }
#});
#console.log(exchangePaths);

urls = %w{ zh/exchanges/OKJ
zh/exchanges/alp-com
zh/exchanges/altcointrader
zh/exchanges/aqx
zh/exchanges/arkham
zh/exchanges/ascendex
zh/exchanges/azbit
zh/exchanges/backpack-exchange
zh/exchanges/bcex
zh/exchanges/bibox
zh/exchanges/biconomy-com
zh/exchanges/bigone
zh/exchanges/bilaxy
zh/exchanges/binance
zh/exchanges/binance_us
zh/exchanges/bingx
zh/exchanges/birake
zh/exchanges/bit
zh/exchanges/bit2c
zh/exchanges/bit2me
zh/exchanges/bitazza
zh/exchanges/bitbank
zh/exchanges/bitbegin
zh/exchanges/bitbns
zh/exchanges/bitcastle
zh/exchanges/bitcoin-me
zh/exchanges/bitcointry-exchange
zh/exchanges/bitdelta
zh/exchanges/bitexen
zh/exchanges/bitexlive
zh/exchanges/bitfinex
zh/exchanges/bitflyer
zh/exchanges/bitget
zh/exchanges/bithumb
zh/exchanges/bitkan
zh/exchanges/bitkub
zh/exchanges/bitlo
zh/exchanges/bitmart
zh/exchanges/bitmex_spot
zh/exchanges/bitonbay
zh/exchanges/bitopro
zh/exchanges/bitrue
zh/exchanges/bitso
zh/exchanges/bitstamp
zh/exchanges/bitsten
zh/exchanges/bitstorage
zh/exchanges/bittime
zh/exchanges/bittrade
zh/exchanges/bitunix
zh/exchanges/bitvavo
zh/exchanges/blockchain_com
zh/exchanges/blofin-spot
zh/exchanges/btc-trade-ua
zh/exchanges/btcbox
zh/exchanges/btcc
zh/exchanges/btcmarkets
zh/exchanges/btcturk-kripto
zh/exchanges/btse
zh/exchanges/bullish_com
zh/exchanges/buyucoin
zh/exchanges/bvox
zh/exchanges/bybit_spot
zh/exchanges/bydfi
zh/exchanges/byte-exchange
zh/exchanges/c-patex
zh/exchanges/catex
zh/exchanges/cex
zh/exchanges/chainex
zh/exchanges/changelly
zh/exchanges/coinbase-exchange
zh/exchanges/coinbase-international
zh/exchanges/coincatch
zh/exchanges/coincheck
zh/exchanges/coindcx
zh/exchanges/coinex
zh/exchanges/coinjar
zh/exchanges/coinlist
zh/exchanges/coinmetro
zh/exchanges/coinone
zh/exchanges/coins-ph
zh/exchanges/coinstore
zh/exchanges/cointr
zh/exchanges/coinup
zh/exchanges/coinw
zh/exchanges/coinzoom
zh/exchanges/cryptal
zh/exchanges/crypto_com
zh/exchanges/cube
zh/exchanges/decentralized
zh/exchanges/deepcoin
zh/exchanges/delta_spot
zh/exchanges/deribit-spot
zh/exchanges/derivatives
zh/exchanges/dextrade
zh/exchanges/difx
zh/exchanges/digifinex
zh/exchanges/digitalexchange-id
zh/exchanges/earnbit
zh/exchanges/ecxx
zh/exchanges/emirex
zh/exchanges/exmo
zh/exchanges/fameex
zh/exchanges/fastex
zh/exchanges/figure-markets
zh/exchanges/fmfw_io
zh/exchanges/foxbit
zh/exchanges/freiexchange
zh/exchanges/gate-io
zh/exchanges/gate-us
zh/exchanges/gemini
zh/exchanges/giottus
zh/exchanges/globe-exchange
zh/exchanges/gmo-japan
zh/exchanges/gopax
zh/exchanges/grovex
zh/exchanges/hashkey-exchange
zh/exchanges/hashkey-global
zh/exchanges/hata
zh/exchanges/hibt
zh/exchanges/hitbtc
zh/exchanges/hotcoin-global
zh/exchanges/htx
zh/exchanges/icrypex
zh/exchanges/independent-reserve
zh/exchanges/indodax
zh/exchanges/inex
zh/exchanges/inx-one
zh/exchanges/itbit
zh/exchanges/kanga
zh/exchanges/kcex
zh/exchanges/kickex
zh/exchanges/kinesis-money
zh/exchanges/koinbx
zh/exchanges/koinpark
zh/exchanges/korbit
zh/exchanges/kraken
zh/exchanges/kucoin
zh/exchanges/latoken
zh/exchanges/lbank
zh/exchanges/lcx
zh/exchanges/localtrade
zh/exchanges/luno
zh/exchanges/max-maicoin
zh/exchanges/mexc
zh/exchanges/mudrex
zh/exchanges/namebase
zh/exchanges/nami_exchange
zh/exchanges/nbx
zh/exchanges/niza-global
zh/exchanges/nonkyc-io
zh/exchanges/novadax
zh/exchanges/oceanex
zh/exchanges/okcoin
zh/exchanges/okx
zh/exchanges/ondo-global-markets
zh/exchanges/onetrading
zh/exchanges/orangex
zh/exchanges/orbix
zh/exchanges/ourbit
zh/exchanges/p2b
zh/exchanges/paribu
zh/exchanges/paymium
zh/exchanges/phemex
zh/exchanges/pionex
zh/exchanges/pointpay
zh/exchanges/poloniex
zh/exchanges/powertrade
zh/exchanges/probit
zh/exchanges/purcow
zh/exchanges/qmall
zh/exchanges/safe-trade
zh/exchanges/safebit
zh/exchanges/secondbtc
zh/exchanges/slex
zh/exchanges/stake-cube
zh/exchanges/tapbit
zh/exchanges/tokenize
zh/exchanges/tokocrypto
zh/exchanges/tokpie
zh/exchanges/toobit
zh/exchanges/tothemoon
zh/exchanges/trade-ogre
zh/exchanges/trubit
zh/exchanges/upbit
zh/exchanges/upbit_indonesia
zh/exchanges/valr
zh/exchanges/vindax
zh/exchanges/wazirx
zh/exchanges/websea
zh/exchanges/weex
zh/exchanges/whitebit
zh/exchanges/woo-network
zh/exchanges/xbo-com
zh/exchanges/xeggex
zh/exchanges/xt
zh/exchanges/young-platform
zh/exchanges/zaif
zh/exchanges/zbx
zh/exchanges/zebpay
zh/exchanges/zondacrypto
zh/exchanges/zoomex
zh/exchanges/fmcpay
zh/exchanges/okex-ordinals
}


def get_link url
  command = "curl -s 'https://www.coingecko.com/#{url}' \
  --compressed \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
  -H 'Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Referer: https://www.coingecko.com/zh/exchanges?page=3' \
  -H 'Connection: keep-alive' \
  -H 'Cookie: _session_id=2b71054eed05a7ce6a365a0ced9a4b4c; OptanonConsent=isGpcEnabled=0&datestamp=Tue+Sep+30+2025+12%3A16%3A50+GMT%2B0800+(%E4%B8%AD%E5%9B%BD%E6%A0%87%E5%87%86%E6%97%B6%E9%97%B4)&version=202508.2.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=22769992-753d-4d87-a606-9e11cd035ac1&interactionCount=1&isAnonUser=1&landingPath=NotLandingPage&groups=C0001%3A1%2CC0003%3A1%2CSPD_BG%3A1%2CC0002%3A1%2CC0004%3A1&AwaitingReconsent=false; _gcl_au=1.1.736864474.1759001210; _ga_LJR3232ZPB=GS2.1.s1759204828$o3$g1$t1759205863$j29$l0$h0$d7NON2hvmrRHPkl-uqFchirk9YQo5ybJUzQ; _ga=GA1.1.361827409.1759001210; cf_clearance=SgutE7NLx4Pe4PKzcw3_NxrX47dgPHJ8c6m3FTC55UA-1759206401-1.2.1.1-zn2f3e3Ai8_feKSOKnmIfoVLYQbWyZxCuCGOjd8mg6PpkGgcUn4UD4.k8kGVqNeNpSCN.2Cg3ucMezUecy4qlEmOOruBMHMst_FnIJcZAvI9b5XIYP2Sfb2.YkcPI2p3MN5ZI.kPAyfKmDv9JEhkrubdvQj8CjaWwOsc3rLLYLxo2IxA5UvNb1vrMlQpcT1SCEEUOvitOg67v4VrQDVpMM2xcRl4yeDY6nLC4UE.xbo; __gads=ID=5b9cc40c674346e1:T=1759001217:RT=1759205831:S=ALNI_Ma9gsjlJIUMGiFV5U8r8uDKjr76GA; __gpi=UID=00001156497dff66:T=1759001217:RT=1759205831:S=ALNI_Map6vmPUA9auBIwdRO2DAQ-ME5XEQ; __eoi=ID=c97821f22d72ea78:T=1759001217:RT=1759205831:S=AA-AfjZIgWM8oOm7LRYwGfyF-68F; cto_bundle=p_RyJV9IZ1ZRNU5FV3dRWHFMVG5SN1pmRVg5dzk1RE5lNWtlQ2RERnhEODQ0eGhDZkhGamFITnAyVWc1QnBIRmpLZXcySGFTcVdzTGtjTnJzUkFpblFFc1VsRXdUNDJGcmJOdXAxTEZ0TDVtVXd1WWJDOEFsJTJCQmdiWk9UeEFYaG4yRDl3VVRBJTJGRFQ1QlF2TXdPdUtKdEpuUzhTdUhzUDJpOVIxWGFZYzllTE53bDlaamlnN09JZkhBWlRLTmtMbHp2SmRE; _rdt_uuid=1759001213520.045234fc-ccba-4cde-9faa-58fc3a0f264d' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Priority: u=0, i' \
  -H 'TE: trailers'
  "
  result = `#{command}`
  doc = Nokogiri::HTML(result)
  a = doc.css('div[data-controller="exchange-show"] a').first
  puts "== url: #{url}"
  puts "== : #{a['href']}"

end

urls.each do |url|
  get_link url rescue "error"
end
