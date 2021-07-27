class ApplicationController < ActionController::Base

  private

  def set_q
    @q = Mountain.ransack(search_params)
  end

  def search_params
    params[:q]&.permit(:name_or_name_en_cont)
  end
end