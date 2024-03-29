class HomesController < ApplicationController
  include Common
  skip_before_action :require_login
  before_action :set_q, only: [:top]
  before_action :set_center_of_jp, only: [:top]

  def top
    mountains_on_map = @q.result(distinct: true)
    gon.mountains_on_map = mountains_on_map
    @area = Settings.area.to_h.values
    # #山の名前で投稿された画像付きツイートが多い順に並べ替えてtop６を取得
    @recommended_mountains = mountains_on_map.order(twitter_result_count: :desc).order(name_en: :desc).first(6)
  end

  def terms_of_use; end

  def privacy_policy; end
end
