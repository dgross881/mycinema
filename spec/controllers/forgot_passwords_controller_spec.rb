require "spec_helper" 

describe ForgotPasswordsController do
  describe "Post #create" do 
    context "with blank input" do
      it "redirect to the forgot password page" do 
        post :create, email: '' 
        expect(response).to redirect_to forgot_password_path
      end 
      it "show an error message" do 
        post :create, email: '' 
        expect(flash[:error]).to have_content("Email can't be blank")
      end 
    end 
  
    context "with existing email" do 
      it "redirect to the forgot password confirmation page" do 
       user = Fabricate(:user, email: "daniel@gmail.com") 
       post :create, email: user.email  
       expect(response).to redirect_to forgot_password_confirmation_path 
      end 
      it "sends out an email confirming reset password" do 
       Fabricate(:user, email: "daniel@gmail.com") 
       post :create, email: "daniel@gmail.com" 
       expect(ActionMailer::Base.deliveries.last.to).to eq(["daniel@gmail.com"])
      end 
    end 
    
    context "with non-exisiting email" do  
      it "redirects to the forgot password page" do
        post :create, email: "fabio@gmail.com"
        expect(response).to redirect_to forgot_password_path 
      end 
      it "shows an error message" do  
        post :create, email: "fabio@gmail.com"
        expect(flash[:error]).to have_content("You must first sign up")
      end 
    end 
  end
end 

