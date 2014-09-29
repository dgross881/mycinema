class Notifier < ActionMailer::Base
  default from: "dgross881@gmail.com"

  def send_welcome_email(user)
    @user = user
    mail to: user.email, subject: "Sign Up Confirmation"
  end

  def forgot_password(user) 
    @user = user 
    mail to: user.email, subject: "Forgot password Reset Confirmation"
  end 
end 

