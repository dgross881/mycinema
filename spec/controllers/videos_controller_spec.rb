require "spec_helper"

describe VideosController do
  let!(:video) { Fabricate.create(:video, title: "Superman") }
  describe "GET #show" do
    context "with authenticated users" do 
      before { already_signed_in }
      it "assigns the requested video to @video" do 
        get :show,  id: video.id
        expect(assigns(:video)).to eq(video) 
      end

      it "sets @reviews for authenticated users" do 
        video = Fabricate(:video)
        review1 = Fabricate(:review, video: video) 
        review2 = Fabricate(:review, video: video) 
        get :show,  id: video.id
        expect(assigns(:reviews)).to match_array [review1, review2]
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
      before { already_signed_in } 
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
