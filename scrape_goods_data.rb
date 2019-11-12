require 'open-uri'
# require 'mechanize'
require 'nokogiri'

# 無在庫転売をやってるであろうユーザーのノーブランド品の一覧
def url(page)
"https://www.amazon.co.jp/s?i=merchant-items&me=A3I4RH9TZZQ78U&rh=p_4%3A%E3%83%8E%E3%83%BC%E3%83%96%E3%83%A9%E3%83%B3%E3%83%89%E5%93%81&dc&page=#{page}&marketplaceID=A1VC38T7YXB528&qid=1573141044&ref=sr_pg_#{page}"
end
max_pagenation = 100
amazon_root_url = "https://www.amazon.co.jp"
charset = nil

max_pagenation.times do |page|

  html = open(url(page)) do |f|
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
    if price >= 1500 && price <= 9000 # 最初のうちは、商品価格が1500円以上9000円以下の商品を探す
      puts asin
      puts title
      puts price
      puts url
    end
    items_amount_in_page += 1
  end
end

