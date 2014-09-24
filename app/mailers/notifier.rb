class Notifier < ActionMailer::Base
  default from: "myflix@gmail.com"

  def send_welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000/sign_in' 
    mail to: user.email, subject: "Sign Up Confirmation"
  end
end 

