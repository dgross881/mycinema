require "spec_helper" 

describe QueueItemsController do
  describe "GET #index" do
    it "sets @que_items to the queue items of the logged in user" do 
      already_signed_in 
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
        before { already_signed_in }
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
     before { already_signed_in }
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

     it "normalizes remaining queueue items" do 
      futurama = Fabricate(:video)
      southpark = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: @user, position: 1, video: futurama) 
      queue_item2 = Fabricate(:queue_item, user: @user, position: 2, video: southpark) 
      delete :destroy, id: queue_item1.id 
      expect(queue_item2.reload.position).to eq(1)
     end  
    end     

  describe "Post update_queue" do
    context 'with valid inputs ' do 
      before { already_signed_in }
      let(:futurama) {Fabricate(:video) } 
      let(:southpark) {Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: @user, position: 1, video: futurama) }
      let(:queue_item2) { Fabricate(:queue_item, user: @user, position: 2, video: southpark) }
      
      it 'redirects to the my queue page' do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_index_path 
      end
        
      it "reorders the users my_queue items" do  
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(@user.queue_items).to eq([queue_item2, queue_item1])
      end 
        
      it "normalizes the position numbers" do  
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(@user.queue_items.map(&:position)).to  eq([1, 2])
      end 
    end 
      
    context "with invalid inputs" do 
      before { already_signed_in }
      let(:futurama) {Fabricate(:video) } 
      let(:southpark) {Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: @user, position: 1, video: futurama) }
      let(:queue_item2) { Fabricate(:queue_item, user: @user, position: 2, video: southpark) }
      
      it "redirects to the my queue page" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_index_path 
      end 
      
      it "sets the falsh error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2.0}]
        expect(flash[:error]).to be_present
      end 
      
      it "does not change the queue items" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.2}]
        expect(queue_item1.reload.position).to eq(1)
      end 
    end 
    
    context "with unauthenticated users" do 
      it "redirects to the sign in path" do 
        post :update_queue, queue_items: [{id: 2, position: 3}, {id: 1, position: 2}]
        expect(response).to redirect_to sign_in_path
      end 
    end 
    
    context "with queue_items that dont belong to the current user" do 
      let(:futurama) {Fabricate(:video) } 
      let(:jim) {Fabricate(:user) }
      let(:southpark) {Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: jim, position: 1, video: futurama) }
      let(:queue_item2) { Fabricate(:queue_item, user: @user, position: 2, video: southpark) }
      before { already_signed_in } 
      it "does not change the queue items" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id:queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end 
    end 
  end
end



