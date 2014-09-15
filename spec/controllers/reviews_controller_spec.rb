require 'spec_helper'
describe ReviewsController do
  describe "POST create" do
    let (:video) { Fabricate(:video) }
    context "with authenticated user" do
       before { already_signed_in }
     context "with valid input" do
       before {
         post :create, review: Fabricate.attributes_for(:review), video_id: video.id
       }
      
      it "redirects to the video show page" do
        expect(response).to redirect_to video
      end
      
      it "creates a review" do
        expect(Review.count).to eq(1)
      end
      
      it "creates a review associated with video" do
        expect(Review.first.video).to eq(video)
      end
      
      it "creates a review associated with the signed in user" do
        expect(Review.first.user).to eq(@user)
      end
    end
    
    context "with invalid input"
      before { 
        post :create, review: {rating: 4}, video_id: video.id
      }   
      
      it "does not create a review" do
        expect(Review.count).to eq(0)
      end
      
      it "renders the videos/show template" do
        expect(response).to render_template 'videos/show'
      end
      
      it "sets @video" do
        expect(assigns(:video)).to eq(video)
      end
      
      it "sets @review" do
        review =  Fabricate(:review, video: video)  
        post :create, review: {rating: 4}, video_id: video.id
        expect(assigns(:reviews)).to match_array([review])
      end
    end
    
    context "with unathenticated user" do
      it "redirects user to the sign in path" do
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
