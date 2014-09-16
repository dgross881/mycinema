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
    current_user.normalize_queue_item_positions
    redirect_to my_queue_index_path 
  end 

  def update_queue
    begin 
      update_queue_items 
      current_user.normalize_queue_item_positions 
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position numbers" 
      redirect_to my_queue_index_path
      return 
    end 
    redirect_to my_queue_index_path
  end 

  private 

  def update_queue_items 
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
          queue_item.update_attributes!(position: queue_item_data["position"], rating: queue_item_data["rating"]) if queue_item.user == current_user 
          flash[:success] = "Your Queue Item list has been updated"
      end 
    end 
  end 

  
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
