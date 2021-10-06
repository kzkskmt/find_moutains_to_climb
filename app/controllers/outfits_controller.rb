class OutfitsController < ApplicationController
  skip_before_action :require_login

  def index
    @outfits = Outfit.all
  end

  private

    def outfit_params
      params.require(:outfit).permit(:title, :lower_limit_temp, :max_elevation, :inner, :outer, :outer_bring, :pant, :accessory, :image)
    end
end
