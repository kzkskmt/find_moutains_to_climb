class MountainsController < ApplicationController
  before_action :set_q, only: %i[index]

  def index
    @mountains_on_map = @q.result(distinct: true)
    @mountains = @mountains_on_map.page(params[:page]).per(12)
  end

  def show
    @mountain = Mountain.find(params[:id])
    # 標高条件をクリアする服装パターンのうち、
    # ① 上限標高(max_elevation)が低い服装パターン順に並べ替える。
    # ② さらに、下限気温(lower_limit_temp)が高い服装パターン順に並べ替えて、先頭２つを取得する（季節が「春秋」か「夏」の２パターンのため）。
    @outfits = Outfit.where('max_elevation > ?', @mountain.elevation).order(max_elevation: :asc, lower_limit_temp: :desc).first(2)
  end
end
