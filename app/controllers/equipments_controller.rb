class EquipmentsController < ApplicationController
  def new
  end

  def edit
    @equipment = Equipment.find(params[:id])
  end

  def update
    @equipment = Equipment.find(params[:id])
    if @equipment.update(equipment_params)
      redirect_to root_path, success: '掲示板を更新しました'
    else
      flash[:danger] = '掲示板を更新できませんでした'
      render :edit
    end
  end


  private

  def equipment_params
    params.require(:equipment).permit(:title, :body, :image)
  end
end
