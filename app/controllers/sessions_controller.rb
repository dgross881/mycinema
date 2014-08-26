class SessionsController < ApplicationController
  def new 
    redirect_to home_path if current_user 
  end 

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id 
      redirect_to home_path, notice: "You are now signed in, enjoy"
    else 
      flash[:error] = "There was a problem logging in. Please check your email and password."
      redirect_to sign_in_path 
    end 
  end 

  def destroy 
    session[:user_id] = nil
    reset_session 
    redirect_to root_path 
  end 
 end 

