class NotifierPreview < ActionMailer::Preview 
  def send_welcome_email
    user = User.create(first_name: "David", last_name: "Gross", email: "barfoo@gmail.com", password: "foobar", password_confirmation: "foobar") 
    mailer = Notifier.send_welcome_email(user) 
    user.destroy 
    mailer 
  end 
end 
