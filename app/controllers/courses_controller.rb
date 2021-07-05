class CoursesController < ApplicationController
  def show
    @mountain = Mountain.find(params[:mountain_id])
  end
end
