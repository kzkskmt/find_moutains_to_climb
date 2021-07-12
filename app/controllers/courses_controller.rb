class CoursesController < ApplicationController
  def show
    @mountain = Mountain.find(params[:mountain_id])
    @course = @mountain.courses.first
  end
end
