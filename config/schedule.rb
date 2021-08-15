# 詳細はgithub参照
# https://github.com/javan/whenever/blob/main/README.md#example-schedulerb-file
# Rails.rootを使用するために必要。wheneverは読み込まれるときにrailsを起動する必要がある
require File.expand_path(File.dirname(__FILE__) + "/environment")

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所。ここでエラー内容を確認する
set :output, "#{Rails.root}/log/cron.log"

# 毎週月曜日にmountainテーブルのtwitter_result_countを更新する。
every :monday, at: '3:00 am' do
  rake 'mountain_contents:search_tweets_counts_by_hashtag'
end