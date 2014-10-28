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
    
    it_behaves_like "require_user_sign_in" do 
      before { get :show, id: video.id }
    end 
  end
    

  describe "Get #search" do 
    context "authenticated user" do 
      before { already_signed_in } 
      it "sets @resuls for authenticated users" do     
        get :search, {search: "Superman"} 
        expect(Sunspot.session).to be_a_search_for(Video)
        expect(Sunspot.session).to have_search_params(:fulltext, "Superman")
      end 
    end

     it_behaves_like "require_user_sign_in" do 
       before { post :search, search_term: "man" }  
    end 
  end  
end 
