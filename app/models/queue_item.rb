class QueueItem < ActiveRecord::Base  
  validates_presence_of :video_id
  validates_numericality_of :position, { only_integer: true}
  belongs_to :user 
  belongs_to :video
 

  delegate :category, to: :video 

  def video_title 
    video.title     
  end 

  def rating 
    review = Review.where(user_id: user.id, video_id: video.id).first  
    review.rating unless review.blank?   
  end

  def category_name 
    video.category.name 
  end 
end 
