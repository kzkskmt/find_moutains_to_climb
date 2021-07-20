class OutfitsController < ApplicationController
  def new
    @outfit = Outfit.new
  end

  def create
    @outfit = Outfit.new(outfit_params)
    if @outfit.save
      redirect_to root_path
    else
      render :edit
    end
  end

  def edit
    @outfit = Outfit.find(params[:id])
  end

  def update
    @outfit = Outfit.find(params[:id])
    if @outfit.update(outfit_params)
      redirect_to root_path
    else
      render :edit
    end
  end


  private

  def outfit_params
    params.require(:outfit).permit(:title, :lower_limit_temp, :max_elevation, :image)
  end
end
