require 'nokogiri'

html = open('mountain_level.html').read
doc = Nokogiri::HTML.parse(html)

# pp doc.at_css('h1') # 条件に合う要素が1つだけの場合
# pp doc.at_css('#through') # CSSセレクタらしくidで指定
# pp doc.at_css('.under') # classで指定。条件に合う最初の要素を取得
# pp doc.at_css('body > div:nth-child(3)') # nth-childも使える
# pp doc.at_css('body > h2:nth-of-type(3)') # nth-of-typeも使える
# pp doc.at_css('h1').class # 戻り値のクラスを確認
# pp doc.at_css('.hogehoge') # 条件に合う要素が存在しない場合

# 全ての行を取得
# pp doc.css('.tacon1 tbody tr')
# 行を取得
# pp doc.at_css('.tacon1 tbody tr')
# 次の行を取得
# pp doc.at_css('.tacon1 tbody tr').next_element
# => doc.at_css('.tacon1 tbody tr').at_css('td').parent　と同じ
# pp doc.at_css('.tacon1 tbody tr').at_css('td')
# pp doc.at_css('.tacon1 tbody tr').css('td')
# pp doc.at_css('.tacon1 tbody tr').css('a')
# pp doc.at_css('.tacon1 tbody tr').css('a').attribute('href')
# pp doc.at_css('.tacon1 tbody tr').css('a').children
# pp doc.at_css('.tacon1 tbody tr').at_css('a').children.first.text
# => "八幡平"
# data = doc.at_css('.tacon1 tbody tr').css('td').children
# data.each do |d|
#   if d.text == '日帰り'
#     pp d.parent.parent.at_css('a').children.first.text
#   end
# end
# pp doc.css('.tacon1 tbody').at_css('tr')

# 全ての行を取得し、各行を評価
data = doc.css('.tacon1 tbody tr')
data.each do |d|
  # 行の「山の名前」の取得
  name = d.at_css('a').children.first.text
  # 行の「難易度」の取得
  puts "#{name}: hard" if d.at_css('a').parent.next_element.text == "★★★★" || d.at_css('a').parent.next_element.text == "☆☆☆"
  puts "#{name}: normal" if d.at_css('a').parent.next_element.text == "★★★" || d.at_css('a').parent.next_element.text == "☆☆"
  puts "#{name}: easy" if d.at_css('a').parent.next_element.text == "★★" || d.at_css('a').parent.next_element.text == "☆"
end
