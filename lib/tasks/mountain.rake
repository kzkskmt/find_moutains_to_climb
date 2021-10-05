namespace :mountain do
  desc '過去１週間で「#山の名前」で投稿されたツイートを取得し、画像urlを抽出する'
  task search_tweets_by_hashtag: :environment do
    bearer_token = ENV['TWITTER_BEARER_TOKEN']
    search_url = 'https://api.twitter.com/2/tweets/search/recent'
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
        "max_results": 20, # 10~100で選択。デフォルトは10
        # "start_time": "2020-07-01T00:00:00Z",
        # "end_time": "2020-07-02T18:00:00Z",
        # "expansions": "attachments.poll_ids,attachments.media_keys,author_id",
        "expansions": 'attachments.media_keys',
        # "tweet.fields": "attachments,author_id,conversation_id,created_at,entities,id,lang"
        # "tweet.fields": "entities",
        # "user.fields": "description"
        "media.fields": 'url' # expansionsのattachments.media_keysをリクエストに含めないと取得できない。
        # "place.fields": "country_code",
        # "poll.fields": "options"
      }

      options = {
        method: 'get',
        headers: {
          "User-Agent": 'v2RecentSearchRuby',
          "Authorization": "Bearer #{bearer_token}"
        },
        params: query_params
      }

      request = Typhoeus::Request.new(search_url, options)
      response = request.run
      result_json = JSON.parse(response.body)
      media_urls = result_json['includes']['media'].map { |n| n['url'] } if result_json['meta']['result_count'] != 0

      twitter_image_urls[:"#{mountain.name}"] = media_urls

      logger.debug twitter_image_urls
    end
  end

  desc '過去１週間で「#山の名前」で投稿されたツイート件数を取得し、保存する'
  task search_tweets_counts_by_hashtag: :environment do
    bearer_token = ENV['TWITTER_BEARER_TOKEN']
    search_url = 'https://api.twitter.com/2/tweets/search/recent'
    # 山の取得件数
    number = Mountain.count

    logger.debug('-' * 12 + '山のツイート数を更新しています' + '-' * 12)
    logger.debug Time.now

    Mountain.first(number).each do |mountain|
      sleep 3
      # 画像付きツイートを取得。has:imagesとしているのは
      # 実際に行っている人（写真が添付されている＝現地に行った、という前提）がどれくらいの数いるのかを取得したいため。
      query = "##{mountain.name} has:images"

      query_params = {
        "query": query, # 必須
        "max_results": 100 # 10~100で選択。デフォルトは10
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
          "User-Agent": 'v2RecentSearchRuby',
          "Authorization": "Bearer #{bearer_token}"
        },
        params: query_params
      }

      request = Typhoeus::Request.new(search_url, options)
      response = request.run
      mountain_count = JSON.parse(response.body)['meta']['result_count']

      mountain.update!(twitter_result_count: mountain_count)
      logger.debug("#{mountain.name}: #{mountain.twitter_result_count}件")
    end
    logger.debug('-' * 19 + '更新しました' + '-' * 19)
  end

  desc 'GoogleMap PlaceAPIを用いて山のplaceIDを取得し、保存する'
  task get_place_id_of_mountains_on_googlemap: :environment do
    number = Mountain.count

    logger.debug('-' * 11 + '山のplace_idを更新しています' + '-' * 11)
    Mountain.first(number).each do |mountain|
      sleep 2
      key = ENV['GOOGLE_MAP_API_KEY_IP']
      lat = mountain.peak_location_lat.to_f
      lng = mountain.peak_location_lng.to_f
      # 検索範囲を入力(m)
      radius = 3000
      # 山はestablishmentに含まれて登録されてるっぽい。
      # type = establishment
      keyword = mountain.name

      # キーワードに日本語を含めて検索するためのURI.parse URI.encode
      url = URI.parse URI.encode("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=#{radius}&type=establishment&keyword=#{keyword}&key=#{key}")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = https.request(request)
      result_json = JSON.parse(response.read_body)

      if result_json['status'] == 'ZERO_RESULTS'
        logger.debug "#{keyword}に該当する山は見つかりませんでした"
        next
      end

      place_id = result_json['results'][0]['place_id']
      place_name = result_json['results'][0]['name']
      mountain.update(place_id: place_id)
      logger.debug("#{keyword}(#{place_name}): #{mountain.place_id}")
    end
    logger.debug('-' * 18 + '更新しました' + '-' * 18)
  end
end
