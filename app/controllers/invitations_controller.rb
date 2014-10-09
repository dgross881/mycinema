class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end 

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      Notifier.delay.send_invite_email(@invitation)
      flash[:success] = "Your Invitation has been sent"
      redirect_to new_invitation_path
    else 
      flash[:error] = "Please fill in the information correctly" 
      render :new 
    end
  end 

  def new_with_invitation_token

  end 
  
  private 
  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end 
end
