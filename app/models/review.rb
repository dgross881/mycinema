class Review < ActiveRecord::Base 
  belongs_to :video
  belongs_to :user 
  validates_presence_of :content 
  validates_presence_of :rating 


  searchable do  
    text :content
    text :rating 
  end 
end 
