class HomesController < ApplicationController
  before_action :set_q, only: %i[top]

  def top
    @mountains = @q.result(distinct: true)
  end
end
