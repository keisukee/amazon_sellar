require 'spreadsheet'

goods_data = []
count = 0
File.open("amazon_goods_data.txt", "r") do |f|
  f.each_line do |line|
    if count % 4 == 0 && line
      goods_data << []
    end
    goods_data[goods_data.length - 1] << line
    count += 1
  end
end

# 新規作成
book = Spreadsheet::Workbook.new
# いろいろな方法でデータを入れられる
# 計算式は入力できない
sheet = book.create_worksheet(name: "1")
sheet.row(0).concat %w{ASIN 商品名 値段 URL}

goods_data.length.times do |i|
  sheet[i + 1, 0] = goods_data[i - 1][0]
  sheet[i + 1, 1] = goods_data[i - 1][1]
  sheet[i + 1, 2] = goods_data[i - 1][2]
  sheet[i + 1, 3] = goods_data[i - 1][3]
end


book.write('test.xls')