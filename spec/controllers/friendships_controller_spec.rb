require 'spec_helper' 

describe FriendshipsController do
  describe "Get #index" do
    it "It sets @friendship to current users following friendship" do
      alice = Fabricate(:user)
      already_signed_in 
      friendship = Fabricate(:friendship, follower: @user, leader: alice) 
      get :index 
      expect(assigns(:friendships)).to eq([friendship])
    end

    it_behaves_like 'require_user_sign_in' do
     before { get :index }
    end 
  end 
  
  describe "Get #create" do
    it "It sets @friendship to current users following friendship" do
      alice = Fabricate(:user)
      already_signed_in 
      post :create, leader_id: alice.id  
      expect(@user.following_friends.count).to eq(1)
    end

    it "It redirects to friends path" do
      alice = Fabricate(:user)
      already_signed_in 
      post :create, leader_id: alice.id  
      expect(response).to redirect_to friends_path
    end 

    it "does not create a relationship if the current user already follows a user" do 
      @user = Fabricate(:user)
      already_signed_in
      expect(Friendship.count).to eq(0)
    end 
    
    it_behaves_like 'require_user_sign_in' do
     before { get :index }
    end 
  end 
 
  
   describe "Method #delete" do
     it_behaves_like "require_user_sign_in" do 
       before { delete :destroy, id: 4}
     end 
    
     it "deletes @friendship to current users following friendship" do
       alice = Fabricate(:user)
       already_signed_in 
       friendship = Fabricate(:friendship, follower: @user, leader: alice) 
       delete :destroy, id: friendship
       expect(Friendship.count).to eq(0)
     end  

    it "redirects to the people page" do  
       alice = Fabricate(:user)
       already_signed_in 
       friendship = Fabricate(:friendship, follower: @user, leader: alice) 
       delete :destroy, id: friendship
       expect(response).to redirect_to friends_path 
    end 

    it "does not delete the relationship if the current user is not the followeri" do 
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      already_signed_in 
      friendship = Fabricate(:friendship, follower: bob, leader: alice) 
      delete :destroy, id: friendship
      expect(Friendship.count).to eq(1)
    end 
  end 
end 

