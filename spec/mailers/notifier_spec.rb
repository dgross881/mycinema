require 'spec_helper'

describe Notifier do
  it "correctly delivers to a user" do 
    user = Fabricate(:user) 
    mailer = Notifier.send_welcome_email(user)
    expect(mailer.to).to eq([user.email])
    expect(mailer.subject).to eq("Sign Up Confirmation")
  end 
end
