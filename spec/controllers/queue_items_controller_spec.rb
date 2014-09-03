require "spec_helper" 

describe QueueItemsController do
  describe "GET #index" do
    it "sets @que_items to the queue items of the logged in user" do 
      already_signed_in @user
      video = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: @user, video_id: video.id )
      queue_item2 = Fabricate(:queue_item, user: @user, video_id: video.id) 
      get :index 
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end 
    
    it "redirects to sign in page for unauthenticated users" do  
      get :index 
      expect(response).to redirect_to sign_in_path
    end 
    
     describe "Post #create" do
        before { already_signed_in @user }
       it "should redirect to the my_queue page" do
        video = Fabricate(:video) 
        post :create, video_id: video.id  
        expect(response).to redirect_to my_queue_index_path  
       end

       it "should create a queue item" do  
         video = Fabricate(:video) 
         post :create, video_id: video.id  
         expect(QueueItem.count).to eq(1)
       end 
       
       it "creates the queue item thats associated with the video" do  
         video = Fabricate(:video) 
         post :create, video_id: video.id 
         expect(QueueItem.first.video).to eq(video)
       end 

       it "creates the queue item thats associated with the user" do
         video = Fabricate(:video)
         post :create, video_id: video.id 
         expect(QueueItem.first.user).to eq(@user)
       end 
       
       it "puts the video as the last one in the queue" do  
         futurama = Fabricate(:video)
         Fabricate(:queue_item, video: futurama, user: @user)
         family_guy = Fabricate(:video)
         post :create, video_id: family_guy.id
         family_guy_queue_item = QueueItem.where(video_id: family_guy.id, user_id: @user.id).first 
         expect(family_guy_queue_item.position).to eq(2)
       end 
      
       it "does not add the video to the queue if the videos already there" do 
         futurama = Fabricate(:video)
         Fabricate(:queue_item, video: futurama, user: @user)
         post :create, video_id: futurama.id
         expect(@user.queue_items.count).to eq(1)
       end 
     end 
   end 
    
   context "unathorized user" do 
     it "redirects to the signin for unauthorized users" do 
       post :create, video_id: 8
       expect(response).to redirect_to sign_in_path
     end 
   end

   describe "destroy  #delete" do
     before { already_signed_in @user }
     it "redirects to my queue page" do 
       video = Fabricate(:video) 
       queue_item = Fabricate(:queue_item, video_id: video.id)
       delete :destroy, id: queue_item.id  
       expect(response).to redirect_to my_queue_index_path
     end 
     
     it "deletes the queue item" do
        futurama = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: futurama, user: @user)
        delete :destroy, id: queue_item.id 
        expect(@user.queue_items.count).to eq(0)
     end  
     
     it "does not delete the queue item if its not the current users queue" do
        futurama = Fabricate(:video)
        dave = Fabricate(:user) 
        queue_item = Fabricate(:queue_item, video: futurama, user: dave)
        delete :destroy, id: queue_item.id 
        expect(dave.queue_items.count).to eq(1)
     end 
    end     
   end
 
 


