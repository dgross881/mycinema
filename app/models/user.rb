class User < ActiveRecord::Base 
  has_secure_password 
  has_many :queue_items, -> {order("position ASC")}

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
end 
