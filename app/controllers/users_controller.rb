class UsersController < ApplicationController
  skip_before_action :require_login, only: [:index, :show, :new, :create]

  def index
    @users = User.all
  end

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
      auto_login(@user)
      redirect_to root_url, success: t('.success')
    else
      flash.now[:danger] = t '.fail'
      render :new
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to user_path(@user), success: t('.success')
    else
      flash.now[:danger] = t '.fail'
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :age, :sex, :password, :password_confirmation, :avatar)
    end
end
