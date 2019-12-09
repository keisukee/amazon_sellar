require 'open-uri'
require 'nokogiri'
require 'dotenv'
require 'amazon/ecs'

Dotenv.load

asin_list = []
File.open("scrape_by_selenium.txt", "r") do |f|
  f.each_line do |line|
    asin_list << line.gsub(/\n/, '')
  end
end

# 初期設定
Amazon::Ecs.configure do |options|
  options[:AWS_access_key_id] = ENV['AWS_ACCESS_KEY_ID'] # 必須
  options[:AWS_secret_key]    = ENV['AWS_SECRET_KEY'] # 必須
  options[:associate_tag]     = ENV['ASSOCIATE_TAG'] # 必須
  options[:response_group]    = 'Medium'                     # レスポンスに含まれる情報量(ふつう
  options[:country]           = 'jp'                         # 国
end

# ページング

asin_list.each do |asin|
  begin
    res = Amazon::Ecs.item_lookup(asin)
    res.items.each do |item|
      doc = Nokogiri::XML(item.to_s)
      url = doc.xpath("//DetailPageURL").text
      url.gsub!(/\?.*$/, "")
      price = doc.xpath("//LowestNewPrice//Amount").text

      if price.to_i > 1500
        puts asin
        puts doc.xpath("//Title").text
        puts price
        puts doc.xpath("//DetailPageURL").text
      end
    end
  rescue => e
    sleep 60 # please request at a slower rateとなったら、60秒待って再度トライ
    retry
  end
end

# asin = asin_list[0]
# res = Amazon::Ecs.item_lookup(asin_list[0])
# # puts res.items.first
# doc = res.items.first.Nokogiri::XML(item.to_s)

# puts "asin: #{asin} price = " + doc.xpath("//LowestNewPrice//Amount").text
# puts doc.xpath("//Title").text

# # asin price url name

