require 'open-uri'
require 'nokogiri'

# 無在庫転売をやってるであろうユーザーのノーブランド品の一覧
def url(sku)
  # https://page.auctions.yahoo.co.jp/jp/auction/s572594019
  "https://page.auctions.yahoo.co.jp/jp/auction/#{sku}"
end
charset = nil

File.open("yahoo_sku_data.txt", "r") do |f|
  f.each_line do |sku|
    sku.chomp!
    # if count % 4 == 0 && line
    #   goods_data << []
    # end
    # goods_data[goods_data.length - 1] << line
    # count += 1
    html = open(url(sku)) do |f|
      charset = f.charset
      f.read
    end
    
    doc = Nokogiri::HTML.parse(html, nil, charset)
    
    # doc.css('div.Price--current') 現在価格

    price = doc.css('div.Price--buynow//dd.Price__value').inner_text # 2,400円（税 0 円）←こういうフォーマットで返ってくる
    price.gsub!(/,/, '')
    price.gsub!(/円.+$/, '')
    price.gsub!(/\n/, '')
    puts price

    # doc.css('div.Price--buynow').each do |node| # 即決価格
    #   puts node
    #   price = doc.css('div.Price--buynow//dd.Price__value').inner_text # 2,400円（税 0 円）←こういうフォーマットで返ってくる
    #   price.gsub!(/,/, '')
    #   price.gsub!(/円.+$/, '')
    #   price.gsub!(/\n/, '')
    #   puts price
    #   # puts asin = doc.css('div.s-result-item')[items_amount_in_page].attribute('data-asin')
    #   # puts title = node.css('span.a-size-medium').inner_text
    #   # puts price = node.css('span.a-price-whole').inner_text.gsub(/,/, '')
    #   # puts url = amazon_root_url + node.css('h2.a-spacing-none//a.a-link-normal').attribute('href')
    # end
  end
end


