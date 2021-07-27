class HomesController < ApplicationController
  before_action :set_q, only: %i[top]

  def top
    @mountains = @q.result(distinct: true)
    @area = %w(北海道 東北 関東 中部 関西 四国 中国 九州)
  end
end
