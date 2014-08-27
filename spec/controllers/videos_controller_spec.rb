require "spec_helper"

describe VideosController do
  let!(:video) { Fabricate.create(:video, title: "Superman") }
  describe "GET #show" do
    context "with authenticated users" do 
      before { already_signed_in(@user) }
      it "assigns the requested video to @video" do 
        get :show,  id: video.id
        expect(assigns(:video)).to eq(video) 
      end
    end 
    
    context "with unathenticated users" do
      it "will redirect to sign in when not logged in" do 
        get :show, id: video.id 
        expect(response).to redirect_to sign_in_path
      end   
    end
  end  

  describe "Get #search" do 
    context "authenticated user" do 
      before { already_signed_in @user } 
      it "sets @resuls for authenticated users" do     
        post :search, search_term: "man"  
        expect(assigns(:results)).to eq([video])
      end 
    end

    context "unahenticated user" do 
      it "redirects to the sign in page" do 
        post :search, search_term: "man"  
        expect(response).to redirect_to sign_in_path
      end 
    end 
  end  
end 
