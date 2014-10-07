require "spec_helper" 

describe UsersController do

  describe "GET #show" do 
    it_behaves_like "require_user_sign_in" do 
      before { get :show, id: 3 }  
    end 

    it "sets @user" do 
      already_signed_in 
      david = Fabricate(:user)
      get :show, id: david.id 
      expect(assigns(:user)).to eq(david)
    end 

  describe "GET #new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end    
  end

  describe "Post #create" do
    context "with valid input" do
      before { post :create, user: 
        { 
          first_name: "Daniel",
          last_name: "Gross",  
          email: "daniel@gmail.com",
          password: "foobar",
          password_confirmation: "foobar" 
        }
      }
      it "creates the user" do
        expect(User.count).to eq 1 
      end 

      it "redirects to the signin page" do  
        expect(response).to redirect_to sign_in_path
      end 
      
      it "makes the user follow the inviter" do 
        david = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: david , recipient_email: "joe@gmail.com")
        post :create, user: { email: "joe@gmail.com", password: "foobar", password_confirmation: "foobar", first_name: "Joe", last_name: "Gross" }, invitation_token: invitation.token
        joe = User.where(email: "joe@gmail.com").first 
        expect(joe.follows?(david)).to be_truthy
      end  
      

      it "makes the inviter follow the user" do 
        david = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: david , recipient_email: "joe@gmail.com")
        post :create, user: { email: "joe@gmail.com", password: "foobar", password_confirmation: "foobar", first_name: "Joe", last_name: "Gross" }, invitation_token: invitation.token
        joe = User.where(email: "joe@gmail.com").first 
        expect(david.follows?(joe)).to be_truthy
      end  


      it "expires the users invitation uppon exceptance" do 
        david = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: david , recipient_email: "joe@gmail.com")
        post :create, user: { email: "joe@gmail.com", password: "foobar", password_confirmation: "foobar", first_name: "Joe", last_name: "Gross" }, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end 
    end 
    
    context "with invalid input" do
      before { post :create, user: 
        { 
          first_name: "Daniel",
          last_name: nil,  
          email: nil,
          password: "foobar",
          password_confirmation: "foobar" 
        }
      }
      it "does not create the user" do 
        expect(User.count).to_not eq 1 
      end 
      
      it "renders the :new template" do 
        expect(response).to render_template :new  
      end  
    end 
   
    context "sending email" do 
      after { ActionMailer::Base.deliveries.clear }
      it "sends out email to the user with valid inputs" do 
        post :create, user: { first_name: "David", last_name: "Gross",  email: "dave@example.com", password: "foobar", password_confirmation: "foobar"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['dave@example.com'])
      end 

      it "sends out email containing the user's name with valid inputs" do 
        post :create, user: { first_name: "David", last_name: "Gross",  email: "dave@example.com", password: "foobar", password_confirmation: "foobar"}
        expect(ActionMailer::Base.deliveries.last.body).to include("David")
      end 
     
      it " does not send out email with invalid inputs" do 
        post :create, user: { first_name: "David", last_name: "Gross",  email: "", password: "foobar", password_confirmation: "foobar"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end 
    end 
  end 

    describe "GET new_with_invitation_token" do
      it "sets @user with recipient's email" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(response).to render_template :new 
      end 
      
      it "sets @user with recipient's email" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end 
      
      it "sets @invitation_token" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(assigns(:invitation_token)).to eq(invitation.token)
      end 
      
      it "redirects to invalid token path for invalid token" do 
        get :new_with_invitation_token, token: "asagewrt4242f" 
        expect(response).to redirect_to expired_token_path
      end 
     end 
   end 
 end 
 
