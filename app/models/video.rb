class Video <  ActiveRecord::Base 
  belongs_to :category
  has_many :reviews, -> { order ("created_at DESC") } 
  has_many :queue_items

  validates :title, presence: true 
  validates :description, presence: true 

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  searchable do 
    text :title  
    text :description, boost: 5
  end 
end 
