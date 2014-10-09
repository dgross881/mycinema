class ForgotPasswordsController < ApplicationController
  def create
    user = User.where(email: params[:email]).first 
    if user 
      Notifier.delay.forgot_password(user)
      redirect_to forgot_password_confirmation_path 
    else 
      flash[:error] = params[:email].blank? ? "Email can't be blank" : "You must first sign up"
      redirect_to forgot_password_path 
    end 
  end 
end
