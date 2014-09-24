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
  end 
end 

