class MountainsController < ApplicationController
  def index
    @mountain = Mountain.first
    @mountains = Mountain.all
  end

  def show
    @mountain = Mountain.find(params[:id])
  end
end
