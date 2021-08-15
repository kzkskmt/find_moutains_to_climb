class HomesController < ApplicationController
  before_action :set_q, only: %i[top]

  def top
    @mountains = @q.result(distinct: true)
    @area = %w(北海道 東北 関東 中部 関西 四国 中国 九州)
    # #山の名前で投稿された画像付きツイートが多い順に並べ替えてtop６を取得
    @recommended_mountains = @mountains.order(twitter_result_count: :desc).first(6)
  end
end
