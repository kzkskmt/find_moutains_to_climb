class HomesController < ApplicationController
  skip_before_action :require_login
  before_action :set_q, only: %i[top]
  before_action :set_center_of_jp, only: %i[top]

  def top
    @mountains_on_map = @q.result(distinct: true)
    @area = %w(北海道 東北 関東 中部 関西 四国 中国 九州)
    # #山の名前で投稿された画像付きツイートが多い順に並べ替えてtop６を取得
    @recommended_mountains = @mountains_on_map.order(twitter_result_count: :desc).order(name_en: :desc).first(6)
  end

  def terms_of_use; end

  def privacy_policy; end
end
