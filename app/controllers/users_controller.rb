class UsersController < ApplicationController
  before_action :logged_in_user, only:[:edit,:update]
  before_action :correct_user, only:[:edit, :update]
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample app"
      redirect_to @user
    else
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def edit
    #@user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profield Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  #Private Method
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please Login"
      redirect_to login_url
    end
  end

  def current_user?(user)
    user == current_user
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
