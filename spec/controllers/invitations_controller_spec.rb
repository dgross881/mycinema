require 'spec_helper'

describe InvitationsController do
  describe "Get #new" do
    it "sets @invitation to a new invitation" do 
      already_signed_in
      get :new 
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end 
    
    it_behaves_like "require_user_sign_in" do 
      before { get :new } 
   end 
  end

  describe "POST #create" do
    it_behaves_like "require_user_sign_in" do 
      before { get :new } 
    end  

    context "with valid input" do 
      it "redirects to the invitation new page" do 
        already_signed_in
        post :create, invitation: { recipient_name: "Daniel Salvery", recipient_email: "daniel881@gmail.com", message: "Please join us at myflix!" } 
        expect(response).to redirect_to new_invitation_path
      end 

      it "creates an invitation" do 
        already_signed_in
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Hey Join this site!"}
        expect(Invitation.count).to eq 1
      end 

     it "it sends an email to a recipient" do 
        already_signed_in
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Hey Join this site!"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end 

      it "sets the flash success message" do 
        already_signed_in 
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Hey Join this site!"}
        expect(flash[:success]).to be_present
      end 
    end 


    context "with invalid input" do 
      after { ActionMailer::Base.deliveries.clear }
      it "renders the :new template" do 
        already_signed_in
        post :create, invitation: { recipient_name: nil , recipient_email: "joe@example.com", message: "Hey Join this site!"}
        expect(response).to render_template :new  
      end 
      
      it "renders the :new template" do 
        already_signed_in
        post :create, invitation: { recipient_name: nil , recipient_email: "joe@example.com", message: "Hey Join this site!"}
        expect(Invitation.count).to eq 0 
      end 
      
      it "does not send an email" do 
        already_signed_in
        post :create, invitation: { recipient_name: nil , recipient_email: "joe@example.com", message: "Hey Join this site!"}
        expect(ActionMailer::Base.deliveries).to be_empty 
      end 
      
      it "renders the a flash error" do 
        already_signed_in
        post :create, invitation: { recipient_name: "David Gross", recipient_name: nil , recipient_email: "joe@example.com", message: nil }
        expect(flash[:error]).to be_present  
      end 
      
      it "renders the a flash error" do 
        already_signed_in
        post :create, invitation: { recipient_name: "David Gross", recipient_name: nil , recipient_email: "joe@example.com", message: nil }
        expect(assigns(:invitation)).to be_present  
      end 
    end
  end 
end
