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
      handle_invitation
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      Stripe::Charge.create( :amount => 400,:currency => "usd", :card => params[:stripeToken], :description => "Charge for test@example.com" )
      Notifier.send_welcome_email(@user).deliver
      redirect_to sign_in_path, notice: "You are now signed up, Please login"
    else 
      render :new, notice: "Please make sure you filled out the correct information"
    end 
  end 

  def new_with_invitation_token
    @invitation = Invitation.where(token: params[:token]).first
    if @invitation
      @user = User.new(email: @invitation.recipient_email)
      @invitation_token = @invitation.token
      render :new 
    else 
      redirect_to expired_token_path
    end 
   end 
  
  private 
  
  def handle_invitation
    if params[:invitation_token].present? 
      @invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(@invitation.inviter) 
      @invitation.inviter.follow(@user)
      @invitation.update_column(:token, nil)
    end 
  end 
  
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :stripe_token)
  end 
end 
