class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new"
      #redirect_to login_path
    end
  end

  def log_in(user)
    session[:user] = user.id
  end

  def current_user
    if session[:user]
      @current_user ||= User.find_by(id: session[:id])
    end
  end

  def destroy
  end

end
