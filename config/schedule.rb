# 詳細はgithub参照
# https://github.com/javan/whenever/blob/main/README.md#example-schedulerb-file
# Rails.rootを使用するために必要。wheneverは読み込まれるときにrailsを起動する必要がある
require File.expand_path("#{File.dirname(__FILE__)}/environment")

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"

# 毎日午前3時にmountainテーブルのtwitter_result_countを更新する。(日本時間で設定)
every 1.day, at: '3:00 am' do
  rake 'mountain:search_tweets_counts_by_hashtag'
end

# 毎月午前3時にmountainテーブルのplace_idを更新する。
every 1.month, at: '3:00 am' do
  rake 'mountain:get_place_id_of_mountains_on_googlemap'
end
