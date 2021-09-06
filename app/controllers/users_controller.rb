class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index; end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, success: t('.success')
    else
      flash.now[:danger] = t '.fail'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update!(user_params)
      redirect_to edit_user_path(@user.id)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # params.require(:user).permit(policy(:user).permitted_attributes)
  end

end
