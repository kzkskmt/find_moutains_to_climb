class MountainsController < ApplicationController
  def index
  end

  def show
    @mountain = Mountain.find(params[:id])
  end
end
