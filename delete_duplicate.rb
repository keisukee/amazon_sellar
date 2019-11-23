goods_data = []
count = 0

# 新規にサーチした商品リスト
File.open("amazon_goods_data.txt", "r") do |f|
  f.each_line do |line|
    if count % 4 == 0 && line
      goods_data << []
    end
    goods_data[goods_data.length - 1] << line
    count += 1
  end
end

asin_list = []
# 既存の出品した商品のASINリスト
File.open("asin_list.txt", "r") do |f|
  f.each_line do |line|
    asin_list << line
  end
end

n = 0
puts goods_data.length
goods_data.each do |goods|
  asin_list.each do |existed_asin|
    if existed_asin == goods[0]
      puts "error duplicate #{existed_asin}"
      goods_data.delete(goods)
      n += 1
      break
    end
  end
end
puts "n = #{n}"
puts goods_data.length


# hoge.txtに、重複データを削除した、新規店舗のデータを追加
File.open("hoge.txt", "w") do |file|
  goods_data.each do |goods|
    file.puts goods[0]
    file.puts goods[1]
    file.puts goods[2]
    file.puts goods[3]
  end
end