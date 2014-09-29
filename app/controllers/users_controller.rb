class UsersController < ApplicationController  
 before_filter  :require_user, only: [:show]
 
  def show 
    @user = User.find(params[:id])
  end 

  def new 
    @user = User.new 
  end 

  def create 
    @user = User.new(user_params) 
    if @user.save
      Notifier.send_welcome_email(@user).deliver
      redirect_to sign_in_path, notice: "You are now signed up, Please login"
    else 
      render :new, notice: "Please make sure you filled out the correct information"
    end 
  end 
  
  private 
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end 
end 
