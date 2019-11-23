require 'open-uri'
# require 'mechanize'
require 'nokogiri'

# 無在庫転売をやってるであろうユーザーのノーブランド品の一覧
def url(page)
  "https://www.amazon.co.jp/s?i=merchant-items&me=A1KEURF5MEPE9S&rh=p_4%3A%E3%83%8E%E3%83%BC%E3%83%96%E3%83%A9%E3%83%B3%E3%83%89%E5%93%81&dc&page=#{page}&marketplaceID=A1VC38T7YXB528&qid=1573654722&ref=sr_pg_#{page}"
end
max_pagenation = 10
amazon_root_url = "https://www.amazon.co.jp"

# User-Agentを偽装しないと、503エラーが出る（アマゾンがなんか判定してるのかも）
opt = {}
opt['User-Agent'] = 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01 '

charset = nil
goods_urls = [] # ショップからURLを取得してくる. 店舗の商品一覧からだと値段が釣り上げられていたりするため

max_pagenation.times do |page|
  html = open(url(page), opt) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)
  items_amount_in_page = 0

  doc.css('div.s-result-item').each do |node|
    asin = doc.css('div.s-result-item')[items_amount_in_page].attribute('data-asin')
    title = node.css('span.a-size-medium').inner_text
    price = node.css('span.a-price-whole').inner_text.gsub(/,/, '').to_i
    url = amazon_root_url + node.css('h2.a-spacing-none//a.a-link-normal').attribute('href')
    goods_urls << url.gsub(/ref.+/, '')
    if price >= 1500 && price <= 9000 # 最初のうちは、商品価格が1500円以上9000円以下の商品を探す
      puts asin
      puts title
      puts price
      puts url
    end
    items_amount_in_page += 1
  end
end

# charset = nil

# goods_urls.each do |goods_url|
#   html = open(goods_url, opt) do |f|
#     charset = f.charset
#     f.read
#   end

#   doc = Nokogiri::HTML.parse(html, nil, charset)
#   puts doc.css('input#ASIN')
#   puts doc.css('span#productTitle').inner_text
#   asin = doc.css('input#ASIN').attribute('value')
#   title = doc.css('span#productTitle').inner_text
#   price = doc.css('span#priceblock_ourprice').inner_text.gsub("/,/", '').gsub("/￥/", '').to_i
#   if price >= 1500 && price <= 9000 # 最初のうちは、商品価格が1500円以上9000円以下の商品を探す
#     puts asin
#     puts title
#     puts price
#     puts goods_url
#   end
# end

