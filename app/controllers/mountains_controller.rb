class MountainsController < ApplicationController
  before_action :set_q, only: %i[index]

  def index
    @mountains_on_map = @q.result(distinct: true)
    @mountains_on_map = @mountains_on_map.select { |mountain| mountain.pref.area == params[:area] } if params[:area]
    # pageはActive Recordのオブジェクトに対して使えるメソッド。selectの戻り値は配列なのでKaminari.paginate_arrayを適用する
    @mountains = Kaminari.paginate_array(@mountains_on_map).page(params[:page]).per(12)
  end

  def show
    @mountain = Mountain.find(params[:id])
    # 詳細画面では該当する山のピンは立てない。
    @mountains_on_map = Mountain.where.not(id: @mountain.id)
    # 標高条件をクリアする服装パターンのうち、
    # ① 上限標高(max_elevation)が低い服装パターン順に並べ替える。
    # ② さらに、下限気温(lower_limit_temp)が高い服装パターン順に並べ替えて、先頭２つを取得する（季節が「春秋」か「夏」の２パターンのため）。
    @outfits = Outfit.where('max_elevation > ?', @mountain.elevation).order(max_elevation: :asc, lower_limit_temp: :desc).first(2)
    @tweet_img_urls = @mountain.search_tweets
  end

  def edit
    @mountain = Mountain.find(params[:id])
  end

  def update
    @mountain = Mountain.find(params[:id])
    if @mountain.update(mountain_params)
      redirect_to edit_mountain_path(@mountain.id)
    else
      render :edit
    end
  end

  private

  def mountain_params
    params.require(:mountain).permit(:name, :name_en, :elevation, :city, :image)
  end
end
