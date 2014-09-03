class QueueItemsController < ApplicationController 
  before_filter :require_user 

  def index 
    @queue_items = current_user.queue_items
  end 

  def create 
    @video = Video.find(params[:video_id])
     add_new_video_to_queue
     redirect_to my_queue_index_path  
  end 

  def destroy
   @queue_item = QueueItem.find(params[:id])
   @queue_item.destroy if current_user.queue_items.include?(@queue_item) 
   redirect_to my_queue_index_path 
  end 

  private 
  def add_new_video_to_queue
    if video_already_queued @video 
      flash[:error] = "#{@video.title} can't be added twice to the queue" 
    else 
      @queue_item = QueueItem.create(video: @video, user: current_user, position: adds_position) 
      flash[:sucess] = "#{@video.title} was successfully added to your queue"
    end 
  end 

  def video_already_queued(video)
    current_user.queue_items.map(&:video).include? video
  end 

  def adds_position
    current_user.queue_items.count + 1
  end 
end 
