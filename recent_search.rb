# This script uses your bearer token to authenticate and make a Search request
# details at https://github.com/twitterdev/Twitter-API-v2-sample-code/blob/main/Recent-Search/recent_search.rb

# 環境変数の読み込み
require 'dotenv'
Dotenv.load

require 'json'
require 'typhoeus'

# bearer tokenを環境変数からセット
bearer_token = ENV["TWITTER_BEARER_TOKEN"]

# Endpoint URL for the Recent Search API
search_url = "https://api.twitter.com/2/tweets/search/recent"

# 検索クエリのセット(上限512文字)
# スペースは'AND'とみなされる。どちらかの条件で検索したければ'OR'でつなげる。
# query = "from:Twitter OR from:TwitterDev OR from:DailyNasa"
# query = "from:sakamot67685105 #か has:media"
# クエリ組み立てについての詳細は公式参照:https://developer.twitter.com/en/docs/twitter-api/tweets/search/integrate/build-a-query
query = "from:sakamot67685105 #か has:images"

# Add or remove parameters below to adjust the query and response fields within the payload
# See docs for list of param options: https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-recent
query_params = {
  "query": query, # 必須
  "max_results": 10, #10~100で選択。デフォルトは10
  # "start_time": "2020-07-01T00:00:00Z",
  # "end_time": "2020-07-02T18:00:00Z",
  # "expansions": "attachments.poll_ids,attachments.media_keys,author_id",
  "expansions": "attachments.media_keys",
  # "tweet.fields": "attachments,author_id,conversation_id,created_at,entities,id,lang"
  "tweet.fields": "entities,text",
  # "user.fields": "description"
  "media.fields": "url" #expansionsのattachments.media_keysをリクエストに含めないと取得できない。
  # "place.fields": "country_code",
  # "poll.fields": "options"
}

def search_tweets(url, bearer_token, query_params)
  options = {
    method: 'get',
    headers: {
      "User-Agent": "v2RecentSearchRuby",
      "Authorization": "Bearer #{bearer_token}"
    },
    params: query_params
  }

  request = Typhoeus::Request.new(url, options)
  response = request.run

  return response
end

response = search_tweets(search_url, bearer_token, query_params)
# 「JSON.parse()」でJSON形式の文字列からハッシュへ変換、「JSON.pretty_generate()」でハッシュをJSON形式にきれいに整形。
# puts response.code, JSON.pretty_generate(JSON.parse(response.body))
# puts JSON.pretty_generate(JSON.parse(response.body))

# 検索結果から画像のurlを抽出する
# puts JSON.parse(response.body)['includes']['media'][0]['url']
# puts JSON.parse(response.body)['includes']['media'][1]['url']
# json_result = JSON.parse(response.body)
# result_count = json_result['meta']['result_count']
# media = json_result['includes']['media']
# media.each do |media|
#   puts media['url']
# end

puts JSON.parse(response.body)['data'][0]['entities']['urls'][0]['url']


