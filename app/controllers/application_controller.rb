class ApplicationController < ActionController::Base
  private

  def set_q
    @q = Mountain.ransack(search_params)
  end

  def search_params
    params[:q]&.permit(:name_or_name_en_cont, :prefecture_code_eq)
  end

  def set_center_of_jp
    # googlemapに日本全体を表示するための、中心経度緯度とズームレベル
    @center_of_map_lat = 38.258595
    @center_of_map_lng = 137.6850225
    @zoom_level_of_map = 4
  end
end