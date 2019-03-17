class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email:params[:password_rest][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = "Email sent with password reset instruction"
      redirect_to root_url
    else
      flash[:danger] = "Email address not Found"
      redirect_to root_url
    end
  end
end
