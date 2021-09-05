class MountainsController < ApplicationController
  skip_before_action :require_login
  before_action :set_q, only: %i[index]
  before_action :set_center_of_jp, only: %i[index]

  def index
    # ツイート数が多い順に並べる（今後な選べ替えもできたらいいかもしれない）
    @mountains_on_map = @q.result(distinct: true).order(twitter_result_count: :desc).order(name_en: :desc)
    # エリアパラメータを持っている場合は、該当する山を抽出
    @mountains_on_map = @mountains_on_map.select { |mountain| mountain.pref.area == params[:area] } if params[:area]
    # pageはActive Recordのオブジェクトに対して使えるメソッド。selectの戻り値は配列なのでKaminari.paginate_arrayを適用する
    @mountains = Kaminari.paginate_array(@mountains_on_map).page(params[:page]).per(12)
  end

  def show
    @mountain = Mountain.find(params[:id])
    # 詳細画面では該当する山のピンは立てない。
    @mountains_on_map = Mountain.where.not(id: @mountain.id)
    @center_of_map_lat = @mountain.peak_location_lat
    @center_of_map_lng = @mountain.peak_location_lng
    @zoom_level_of_map = 12
    # 標高条件をクリアする服装パターンのうち、
    # ① 上限標高(max_elevation)が低い服装パターン順に並べ替える。
    # ② さらに、下限気温(lower_limit_temp)が高い服装パターン順に並べ替えて、先頭２つを取得する（季節が「春秋」か「夏」の２パターンのため）。
    @outfits = Outfit.where('max_elevation > ?', @mountain.elevation).order(max_elevation: :asc, lower_limit_temp: :desc).first(2)
    # twitterAPIを用いて、最新画像を取得（現在の表示はAPI規約違反しているため一旦停止中）
    # @tweet_img_urls = @mountain.search_tweets
    # googlemap placesAPIを用いて、画像を取得
    @google_img_urls = @mountain.search_googlemap_place
    
    @posts = @mountain.posts.includes(:user)
  end

  # def edit
  #   @mountain = Mountain.find(params[:id])
  # end

  # def update
  #   @mountain = Mountain.find(params[:id])
  #   if @mountain.update(mountain_params)
  #     redirect_to edit_mountain_path(@mountain.id)
  #   else
  #     render :edit
  #   end
  # end

  private

  def mountain_params
    params.require(:mountain).permit(:name, :name_en, :elevation, :city, :image)
  end
end
