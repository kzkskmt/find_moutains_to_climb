class PostsController < ApplicationController

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(params_post)
    if @post.save
      redirect_to user_path(current_user), success: t('.success')
    else
      flash.now[:danger] = t '.fail'
      render :new
    end
  end

  private

  def params_post
    params.require(:post).permit(:title, :body, :mountain_id)
  end
end
