require "selenium-webdriver"

driver = Selenium::WebDriver.for :firefox
def url(page)
  "https://www.amazon.co.jp/s?i=merchant-items&me=AE1J9YHBWV7JY&dc&page=#{page}&marketplaceID=A1VC38T7YXB528&ref=sr_pg_#{page}"
end

max_pagenation = 100

max_pagenation.times do |page|
  sleep(rand(3.0..7.0))
  driver.navigate.to url(page)
  # elements = driver.find_elements(:class, "a-size-medium")
  # elements = driver.find_elements(:class, "a-link-normal")
  elements = driver.find_elements(:class, "s-result-item")

  elements.each_with_index do |element, index|
    # link = driver.find_element(:link, "大相撲 カレンダー 2020年 令和2年")
    if index > 16 # 1ページあたり16個の商品があるので
      break
    end
    puts element.attribute("data-asin")
    # puts element.attribute(:href)
  end

  puts "#{page}: ----------"

end

driver.quit
