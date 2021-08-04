require 'open-uri'
require 'nokogiri'

mountain_name = '富士山'
base_url = URI.encode "https://www.photo-ac.com/main/search?q=#{mountain_name}&qt=&qid=&creator=&ngcreator=&nq=&srt=dlrank&orientation=all&sizesec=all&color=all&model_count=-1&age=all&mdlrlrsec=all&sl=ja&type_search=phrase
"

html = URI.open(base_url).read
doc = Nokogiri::HTML.parse(html)

# 検索結果の画像データを全て取得
data = doc.css('.photo-img').first(20)
image_data = data.first
no_image = []

# 一つも見つからなかったら、break
if image_data.nil?
  puts "#{mountain_name}の検索結果はゼロでした"
  no_image.push(mountain_name)
  # break

else  
20.times do |timesCount|
  sleep 1
  image_data_size = image_data.at_css('.img-hover-actions').at_css('a').attribute('data-size-s').value
  if image_data_size == "640x480"
    break
  end
  image_data = image_data.next_element
  puts "#{timesCount + 1}回目:サイズ640x480の画像を探しています"
  break if image_data.nil?
end

if image_data.nil?
  puts "サイズ640x480の#{mountain_name}画像は見つかりませんでした"
  no_image.push(mountain_name)
else
  pp image_data.at_css('.img-hover-actions').at_css('a').attribute('data-title').value

  # 画像サイズ640x480の画像urlを取得
  img_src = image_data.at_css('.thumbnail').attribute('data-src')
  img_url = img_src.value

  pp img_url

  # sleep 1
  # file = "#{mountain_name}.jpg"
  # open(file, 'w') do |pass|
  #   open(img_url) do |recieve|
  #     pass.write(recieve.read)
  #   end
  end
end

