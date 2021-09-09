class LikesController < ApplicationController
  def create
    like = current_user.likes.build(post_id: params[:post_id])
    like.save!
    redirect_back(fallback_location: root_path)
  end

  def destroy
    like = current_user.likes.find_by(post_id: params[:post_id], user_id: current_user.id)
    like.destroy!
    redirect_back(fallback_location: root_path)
  end
end
