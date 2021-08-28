namespace :scraping do
  desc "フリー素材サイト「写真AC」から640x480サイズの画像をスクレイピングし、指定したファイルに保存する"
  task scrape_images_on_pic_ac: :environment do
    # 山の取得件数
    number = 

    # 保存できなかった山を後で表示するためのarrey
    no_image = []

    Mountain.first(number).each do |mountain|
      sleep 1
      mountain_name = mountain.name
      mountain_name_en = mountain.name_en
      
      base_url = URI.encode "https://www.photo-ac.com/main/search?q=#{mountain_name}&qt=&qid=&creator=&ngcreator=&nq=&srt=dlrank&orientation=all&sizesec=all&color=all&model_count=-1&age=all&mdlrlrsec=all&sl=ja&type_search=phrase
      "

      html = URI.open(base_url).read
      doc = Nokogiri::HTML.parse(html)

      # 先頭20件の検索結果の画像データを取得
      data = doc.css('.photo-img').first(20)
      image_data = data.first

      # 1件もヒットしなければ、break
      if image_data.nil?
        puts "#{mountain_name}の検索結果はゼロでした"
        no_image.push("#{mountain.id}_#{mountain_name}")
        break
      end

      # 先頭20件の検索結果のうち、画像サイズ640x480の画像urlを取得
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

      # サイズの合う画像が見つかった場合は保存する
      if image_data.nil?
        puts "サイズ640x480の#{mountain_name}画像は見つかりませんでした"
        no_image.push("#{mountain.id}_#{mountain_name}")
      else
        pp image_data.at_css('.img-hover-actions').at_css('a').attribute('data-title').value

        # 画像サイズ640x480の画像urlを取得
        img_src = image_data.at_css('.thumbnail').attribute('data-src')
        img_url = img_src.value

        # ファイル保存位置の設定
        file = "./app/assets/images/mountain_images/#{mountain.id}_#{mountain_name_en}.jpg"
        sleep 1
        open(file, 'w+b') do |pass|
          open(img_url) do |recieve|
            pass.write(recieve.read)
          end
        end

        # 保存した画像データ
        puts "id:#{mountain.id}, #{mountain.name}の画像を保存しました"
      end

      # 画像が見つからなかった山の名前を出力
      puts '-'*40, "画像が見つからなかった山は以下の#{no_image.count}件です"
      puts no_image
    end
  end

  desc "フリー素材サイト「写真AC」から640x480サイズの画像をスクレイピングし、urlからcarrierwaveメソッドで保存する"
  task scrape_images_on_pic_ac_save_using_carrierwave: :environment do
    # 山の取得件数
    number = 

    no_image = []

    Mountain.first(number).each do |mountain|
      sleep 1
      mountain_name = mountain.name
      mountain_name_en = mountain.name_en
      
      base_url = URI.encode "https://www.photo-ac.com/main/search?q=#{mountain_name}&qt=&qid=&creator=&ngcreator=&nq=&srt=dlrank&orientation=all&sizesec=all&color=all&model_count=-1&age=all&mdlrlrsec=all&sl=ja&type_search=phrase
      "

      html = URI.open(base_url).read
      doc = Nokogiri::HTML.parse(html)

      # 先頭20件の検索結果の画像データを取得
      data = doc.css('.photo-img').first(20)
      image_data = data.first

      # 1件もヒットしなければ、break
      if image_data.nil?
        puts "#{mountain_name}の検索結果はゼロでした"
        no_image.push("#{mountain.id}: #{mountain_name}")
        break
      end

      # 先頭20件の検索結果のうち、画像サイズ640x480の画像urlを取得
      20.times do |timesCount|
        sleep 1
        image_data_size = image_data.at_css('.img-hover-actions').at_css('a').attribute('data-size-s').value
        if image_data_size == "640x480"
          break
        end
        image_data = image_data.next_element
        puts "#{timesCount + 1}件目:サイズ(640x480)が一致しませんでした。"
        break if image_data.nil?
      end

      # サイズの合う画像が見つかった場合は保存する
      if image_data.nil? || image_data.at_css('.img-hover-actions').nil?
        puts "サイズ640x480の#{mountain_name}画像は見つかりませんでした"
        # 画像パスが既に保存されている場合はimageカラムをnilにする。
        mountain.remove_image = true
        mountain.save!
        no_image.push("#{mountain.id}: #{mountain_name}")
      else
        pp image_data.at_css('.img-hover-actions').at_css('a').attribute('data-title').value

        # 画像サイズ640x480の画像urlを取得
        img_src = image_data.at_css('.thumbnail').attribute('data-src')
        img_url = img_src.value

        sleep 1
        # carrierwaveのヘルパーメソッド「remote_image_url」で画像を保存する
        mountain.remote_image_url = img_url
        mountain.save!

        # 保存した画像データ
        puts "id:#{mountain.id}: #{mountain.name}の画像を保存しました"
      end
    end
    # 画像が見つからなかった山の名前を出力
    puts '-'*40, "画像が見つからなかった山は以下の#{no_image.count}件です"
    puts no_image
  end

  desc "フリー素材サイト「写真AC」から640x480サイズの画像をスクレイピングし、画像属性がnilのデータにurlからcarrierwaveメソッドで保存する"
  task update_images_on_pic_ac_if_image_nil: :environment do
    no_image = []

    Mountain.where(image: nil).each do |mountain|
      sleep 1
      mountain_name = mountain.name
      mountain_name_en = mountain.name_en
      
      base_url = URI.encode "https://www.photo-ac.com/main/search?q=#{mountain_name}&qt=&qid=&creator=&ngcreator=&nq=&srt=dlrank&orientation=all&sizesec=all&color=all&model_count=-1&age=all&mdlrlrsec=all&sl=ja&type_search=phrase
      "

      html = URI.open(base_url).read
      doc = Nokogiri::HTML.parse(html)

      # 先頭20件の検索結果の画像データを取得
      data = doc.css('.photo-img').first(20)
      image_data = data.first

      # 先頭の画像は大概微妙なので
      image_data = image_data.next_element

      # 画像が見つかった場合は保存する
      if image_data.nil? || image_data.at_css('.img-hover-actions').nil?
        puts "画像は見つかりませんでした"
        mountain.remove_image = true
        mountain.save!
        no_image.push("#{mountain.id}: #{mountain_name}")
      else
        pp image_data.at_css('.img-hover-actions').at_css('a').attribute('data-title').value

        # 画像サイズ640x480の画像urlを取得
        img_src = image_data.at_css('.thumbnail').attribute('data-src')
        img_url = img_src.value

        sleep 1
        # carrierwaveのヘルパーメソッド「remote_image_url」で画像を保存する
        mountain.remote_image_url = img_url
        mountain.save!

        # 保存した画像データ
        puts "id:#{mountain.id}: #{mountain.name}の画像を保存しました"
      end
    end
    # 画像が見つからなかった山の名前を出力
    puts '-'*40, "画像が見つからなかった山は以下の#{no_image.count}件です"
    puts no_image
  end

  desc "山の難易度を登山情報サイト「momonayama.net」からスクレイピングし、保存する"
  task scrape_climbing_level_on_momonayama_net: :environment do
    base_url = URI.encode 'https://www.momonayama.net/hundred_mt_list_data/difficulty.html'

    html = URI.open(base_url).read
    doc = Nokogiri::HTML.parse(html)
    
    data = doc.css('.tacon1 tbody tr')
    data.each do |d|
      sleep 1
      # 行の「山の名前」の取得
      name = d.at_css('a').children.first.text
      # 名前からDB検索
      m = Mountain.find_by(name: name)
      # 名前検索でDBから見つからない場合は次のループへ
      if m.nil?
        puts "#{name}に該当する山は見つかりませんでした"
        next
      end
      # 行の「難易度」の取得
      if d.at_css('a').parent.next_element.text == "★★★★" || d.at_css('a').parent.next_element.text == "☆☆☆"
        m.level = :hard
        m.save!
      elsif d.at_css('a').parent.next_element.text == "★★★" || d.at_css('a').parent.next_element.text == "☆☆"
        m.level = :normal
        m.save!
      elsif d.at_css('a').parent.next_element.text == "★★" || d.at_css('a').parent.next_element.text == "☆"
        m.level = :easy
        m.save!
      else
        puts "#{m.name}の難易度を保存できませんでした"
      end
    end
  end
end
