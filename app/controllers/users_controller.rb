class UsersController < ApplicationController
  before_action :logged_in_user, only:[:edit,:update,:destroy]
  before_action :correct_user,   only:[:edit, :update]
  before_action :admin_user,     only:[:destroy,]
  
  def index
    @users = User.where(activated:true).paginate(page:params[:page])
  end
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page:params[:page])
    redirect_to root_url unless @user.activated == true
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_email_activation
      flash[:info] = "Please Check email to activate your account"
      redirect_to root_url
    else
      render "new"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Delete User"
    redirect_to users_url
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

  def current_user?(user)
    user == current_user
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(login_url) unless current_user.admin?
  end
end
