require "spec_helper"

describe SessionsController do
  describe "GET #new" do
    context "Signed in user" do 
      before { already_signed_in @user }  
      it "returns the signed in user to home path when trying to visit signin path" do 
        get :new,  user_id: @user.id       
        expect(response).to redirect_to home_path 
      end 
    end 
  
    context "Unsigned in user" do
      it "renders the sign_in template when not signed in" do    
        get :new  
        expect(response).to render_template :new  
      end 
    end
  end 

  describe "PATCH #create" do
    context "Sign in with correct information" do 
      let(:user) {User.create(
                  first_name: "Daniel",
                  last_name: "Boon", 
                  email: "foo@gmail.com", 
                  password: "foobar", 
                  password_confirmation: "foobar")} 
     
      it "redirects to home path after signing in" do 
        login_user 
        expect(response).to be_redirect 
        expect(response).to redirect_to(home_path)
      end 

      it "finds the correct registered user" do 
        expect(User).to receive(:find_by).with(email: "foo@gmail.com").and_return(user)
        login_user 
      end 

      it "authinticates the registered user" do 
        User.stub(:find_by).and_return(user)
        expect(user).to receive(:authenticate)
        login_user 
      end 

      it "returnes a notice after successful sign in" do 
        login_user 
        expect(flash[:notice]).to match(/you are now signed in, enjoy/i)
      end 
       
      it "sets the user id in the session" do 
        login_user 
        expect(session[:user_id]).to eq(user.id)      
      end 
    end
  
  context "Sign in with incorrect information" do
    let(:invalid_user) {User.create(
                first_name: "Daniel",
                last_name: "Boon", 
                email: "foo@gmail.com", 
                 password: "foobar", 
                password_confirmation: "foobar")} 
      
    it "sets a flash error message with incorrect information" do 
      post :create,  email: nil, password: nil  
      expect(flash[:error]).to match(/There was a problem logging in. Please check your email and password./i)
    end 
    
    it "redirects to sign in  with inccorrect password" do 
      post :create, email: invalid_user.email, password: "thishsishs" 
      expect(response).to redirect_to sign_in_path 
    end 
     
     it "redirects to sign in with inccorect email" do 
      post :create, email: "bobsburgers@gmail.com", password: invalid_user.password
      expect(response).to redirect_to sign_in_path 
     end 
   end 
  end
end

private 
def login_user 
 post :create, email: user.email, password: user.password 
end 
