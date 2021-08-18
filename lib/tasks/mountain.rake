namespace :mountain do

  desc "過去１週間で「#山の名前」で投稿されたツイートを取得し、画像urlを抽出する"
  task search_tweets_by_hashtag: :environment do
    bearer_token = ENV["TWITTER_BEARER_TOKEN"]
    search_url = "https://api.twitter.com/2/tweets/search/recent"

    # 山の取得件数
    number = 

    twitter_image_urls = {}
    Mountain.first(number).each do |mountain|
      # リクエスト上限が450回/15分 = 1回/2秒なのでsleep2以上は入れとく。
      sleep 3
      # クエリの組み立て方について https://developer.twitter.com/en/docs/twitter-api/tweets/search/integrate/build-a-query
      query = "##{mountain.name} has:images"

      # クエリのパラメータについて https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-recent
      query_params = {
        "query": query, # 必須
        "max_results": 20, #10~100で選択。デフォルトは10
        # "start_time": "2020-07-01T00:00:00Z",
        # "end_time": "2020-07-02T18:00:00Z",
        # "expansions": "attachments.poll_ids,attachments.media_keys,author_id",
        "expansions": "attachments.media_keys",
        # "tweet.fields": "attachments,author_id,conversation_id,created_at,entities,id,lang"
        # "tweet.fields": "entities",
        # "user.fields": "description"
        "media.fields": "url" #expansionsのattachments.media_keysをリクエストに含めないと取得できない。
        # "place.fields": "country_code",
        # "poll.fields": "options"
      }

      options = {
        method: 'get',
        headers: {
          "User-Agent": "v2RecentSearchRuby",
          "Authorization": "Bearer #{bearer_token}"
        },
        params: query_params
      }
    
      request = Typhoeus::Request.new(search_url, options)
      response = request.run
      result_json = JSON.parse(response.body)
      media_urls = result_json['includes']['media'].map {|n| n['url'] } if result_json['meta']['result_count'] != 0

      twitter_image_urls[:"#{mountain.name}"] = media_urls

      puts twitter_image_urls
    end
  end

  desc "過去１週間で「#山の名前」で投稿されたツイート件数を取得し、保存する"
  task search_tweets_counts_by_hashtag: :environment do
    bearer_token = ENV["TWITTER_BEARER_TOKEN"]
    search_url = "https://api.twitter.com/2/tweets/search/recent"
    # 山の取得件数
    number = Mountain.count

    puts '-'*10 + '山のツイート数を更新しています' + '-'*10
    Mountain.first(number).each do |mountain|
      sleep 3
      # 画像付きツイートを取得。has:imagesとしているのは
      # 実際に行っている人（写真が添付されている＝現地に行った、という前提）がどれくらいの数いるのかを取得したいため。
      query = "##{mountain.name} has:images"

      query_params = {
        "query": query, # 必須
        "max_results": 100, #10~100で選択。デフォルトは10
        # "start_time": "2020-07-01T00:00:00Z",
        # "end_time": "2020-07-02T18:00:00Z",
        # "expansions": "attachments.poll_ids,attachments.media_keys,author_id",
        # "tweet.fields": "attachments,author_id,conversation_id,created_at,entities,id,lang"
        # "user.fields": "description",
        # "media.fields": "url", #expansionsのattachments.media_keysをリクエストに含めないと取得できない。
        # "place.fields": "country_code",
        # "poll.fields": "options"
      }

      options = {
        method: 'get',
        headers: {
          "User-Agent": "v2RecentSearchRuby",
          "Authorization": "Bearer #{bearer_token}"
        },
        params: query_params
      }
    
      request = Typhoeus::Request.new(search_url, options)
      response = request.run
      mountain_count = JSON.parse(response.body)['meta']['result_count']

      mountain.update!(twitter_result_count: mountain_count)
      puts "#{mountain.name}: #{mountain.twitter_result_count}件"
    end
    puts '-'*19 + '更新しました' + '-'*19
  end

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
      puts "画像が見つからなかった山は以下の#{no_image.count}件です"
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
      if image_data.nil?
        puts "サイズ640x480の#{mountain_name}画像は見つかりませんでした"
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
    puts "画像が見つからなかった山は以下の#{no_image.count}件です"
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

  desc "GoogleMap PlaceAPIを用いて山のplaceIDを取得し、保存する"
  task get_place_id_of_mountains_on_googlemap: :environment do
    number = Mountain.count

    puts '-'*10 + '山のplace_idを更新しています' + '-'*10
    Mountain.first(number).each do |mountain|
      sleep 2
      key = ENV["GOOGLE_MAP_API_KEY_IP"]
      lat = mountain.peak_location_lat.to_f
      lng = mountain.peak_location_lng.to_f
      # 検索範囲を入力(m)
      radius = 3000
      # 山はestablishmentに含まれて登録されてるっぽい。
      # type = establishment
      keyword = mountain.name

      # キーワードに日本語を含めて検索するためのURI.parse URI.encode
      url = URI.parse URI.encode ("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=#{radius}&type=establishment&keyword=#{keyword}&key=#{key}")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = https.request(request)
      result_json = JSON.parse(response.read_body)

      if result_json['status'] == 'ZERO_RESULTS'
        puts "#{keyword}に該当する山は見つかりませんでした"
        next
      end

      place_id = result_json['results'][0]['place_id']
      place_name = result_json['results'][0]['name']
      mountain.update(place_id: place_id)
      puts "#{keyword}(#{place_name}): #{mountain.place_id}"
    end
    puts '-'*18 + '更新しました' + '-'*18
  end
end
