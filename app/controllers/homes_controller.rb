class HomesController < ApplicationController
  def top
    @mountains = Mountain.all
  end
end
