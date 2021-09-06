class PostsController < ApplicationController

  def new
    @post = current_user.posts.build
    @post.mountain_id = params[:mountain_id] if params[:mountain_id]
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to user_path(current_user), success: t('.success')
    else
      flash.now[:danger] = t '.fail'
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to user_path(@post.user), success: t('.success')
    else
      flash[:danger] = t '.fail'
      render :edit
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    # 元のページへリダイレクト
    redirect_to request.referer, success: t('.success')
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :mountain_id)
  end
end
