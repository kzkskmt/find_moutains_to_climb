class MountainsController < ApplicationController
  include Common
  skip_before_action :require_login
  before_action :set_q, :set_center_of_jp, only: [:index]
  before_action :set_mountain, only: [:show]
  before_action :set_params_for_google_map, :set_params_for_youtube, :set_key_for_openweather_map, only: [:show]

  def index
    mountains_on_map = @q.result(distinct: true).order(twitter_result_count: :desc).order(name_en: :desc)
    mountains_on_map = mountains_on_map.select { |mountain| mountain.pref.area == params[:area] } if params[:area]
    gon.mountains_on_map = mountains_on_map
    # pageはActive Recordのオブジェクトに対して使えるメソッド。selectの戻り値は配列なのでKaminari.paginate_arrayを適用する
    @mountains = Kaminari.paginate_array(mountains_on_map).page(params[:page]).per(12)
  end

  def show
    # 標高条件をクリアする服装パターンのうち、
    # ① 上限標高(max_elevation)が低い服装パターン順に並べ替える。
    # ② さらに、下限気温(lower_limit_temp)が高い服装パターン順に並べ替えて、先頭２つを取得する（季節が「春秋」か「夏」の２パターンのため）。
    outfits = Outfit.where('max_elevation > ?', @mountain.elevation).order(max_elevation: :asc, lower_limit_temp: :desc).first(2)
    gon.outfit_1 = outfits.first
    gon.outfit_2 = outfits.second
    @posts = @mountain.posts.includes(:user)
  end

  private

    def mountain_params
      params.require(:mountain).permit(:name, :name_en, :elevation, :city, :image)
    end

    def set_mountain
      @mountain = Mountain.find(params[:id])
    end

    def set_params_for_google_map
      gon.center_of_map_lat = @mountain.peak_location_lat
      gon.center_of_map_lng = @mountain.peak_location_lng
      gon.zoom_level_of_map = 12
      # 詳細画面では該当する山のピンは立てない。
      gon.mountains_on_map = Mountain.where.not(id: @mountain.id)
      @google_img_urls = @mountain.search_googlemap_place
    end

    def set_params_for_youtube
      gon.youtube_key = ENV['GOOGLE_MAP_API_KEY']
      gon.youtube_keyword = "#{@mountain.name}登山"
      gon.youtube_maxresult = 4
    end

    def set_key_for_openweather_map
      gon.openweather_map_key = ENV['OPENWEATHER_MAP_API_KEY']
    end
end
