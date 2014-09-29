require 'spec_helper'

describe Notifier do
  it "correctly delivers welcome email to a user" do 
    user = Fabricate(:user) 
    mailer = Notifier.send_welcome_email(user)
    expect(mailer.to).to eq([user.email])
    expect(mailer.subject).to eq("Sign Up Confirmation")
  end 
  
  it "correctly delivers sign up confirmation to a user" do 
    user = Fabricate(:user) 
    user.update_column(:token, user.token)
    mailer = Notifier.forgot_password(user)
    expect(mailer.to).to eq([user.email])
    expect(mailer.subject).to eq("Forgot password Reset Confirmation")
  end 
end
