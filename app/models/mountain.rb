class Mountain < ApplicationRecord
  include JpPrefecture
  mount_uploader :image, ImageUploader
  jp_prefecture :prefecture_code, method_name: :pref

  has_many :courses

  enum level: { 初級: 0, 中級: 1, 上級: 2 }

  def search_tweets
    bearer_token = ENV["TWITTER_BEARER_TOKEN"]
    search_url = "https://api.twitter.com/2/tweets/search/recent"
    query = "##{self.name} has:images"

    query_params = {
      "query": query, # 必須
      "max_results": 20, #検索結果の取得件数。10~100で選択。デフォルトは10
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
    # 写真付きツイートが見つかった場合、画像のurlをmedia_urlに格納
    media_urls = result_json['includes']['media'].map {|n| n['url'] } if result_json['meta']['result_count'] != 0
    
    return media_urls
  end

end