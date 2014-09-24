class User < ActiveRecord::Base 
  has_secure_password 
  has_many :reviews 
  has_many :queue_items, -> {order("position ASC")}
  has_many :following_friends, class_name: "Friendship", foreign_key: :follower_id

  validates_presence_of :email, :password, :password_confirmation, :first_name, :last_name 

  validates :email, presence: true, 
                  uniqueness: true, 
                  format: {
                    with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9\.-]+\.[A-Za-z]+\Z/
                  }
 
  before_save :downcase_email 

  def downcase_email
    self.email = email.downcase 
  end

  def full_name 
    first_name + " " + last_name 
  end 
  
  def normalize_queue_item_positions
    self.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end 

  def follows?(another_user)
    following_friends.map(&:leader).include?(another_user)  
  end 

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end 
end 

