require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do 
    it "renders show template if the token is valid" do 
      david = Fabricate(:user) 
      david.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end 
    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path 
    end
    it "sets the token" do 
      david = Fabricate(:user) 
      david.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns[:token]).to eq('12345') 
    end 
  end 
  describe "POST #create" do
    
    context "with valid token" do 
      it "redirects to the sign in page" do 
        david = Fabricate(:user)
        david.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to sign_in_path 
      end 
      it "updates the users password" do 
        daniel = Fabricate(:user, password: 'old_password', password_confirmation: 'old_password')
        daniel.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password', password_confirmation: 'new_password'
        daniel.reload
        expect(daniel.authenticate('new_password')).to be_truthy 
      end 
      it "sets the flash success message" do 
        daniel = Fabricate(:user, password: 'old_password', password_confirmation: 'old_password')
        daniel.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password', password_confirmation: 'new_password'
        daniel.reload
        expect(flash[:success]).to be_present
      end 
      it "regenerates the users token" do 
        daniel = Fabricate(:user, password: 'old_password', password_confirmation: 'old_password')
        daniel.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password', password_confirmation: 'new_password'
        daniel.reload
        expect(daniel[:token]).not_to eq('12345')
        end 
      end 
    
    context "with invalid token" do 
      it "redirects to the expired token path" do
        post :create, token: '12345', password: 'some_password', password_confirmation: 'some_password'
        expect(response).to redirect_to expired_token_path        
      end

    end 
  end
end
