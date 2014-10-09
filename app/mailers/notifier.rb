class Notifier < ActionMailer::Base
  default from: ENV['GMAIL_USERNAME']

  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: "Sign Up Confirmation"
  end

  def forgot_password(user) 
    @user = user 
    mail to: user.email, subject: "Forgot password Reset Confirmation"
  end 

  def send_invite_email(invitation)
     @invitation = invitation
     mail to: invitation.recipient_email, from: "info@myflix", subject: "Invitation to join MyFlix"
  end
end 

