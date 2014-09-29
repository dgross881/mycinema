require 'spec_helper' 

describe User do
  let(:user) { Fabricate(:user) }
   
  context "Valid attributes for users" do  
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation) }
    it { should validate_uniqueness_of(:email) } 
    it { should have_many(:queue_items).order("position ASC") }
    it { should have_many(:reviews) }

    it "must be a verified email address" do 
      user.email = "Thisisnoemail" 
      expect(user).to_not be_valid 
   end 
 end 

  context "#token" do 
    it "generates a random token fora user" do 
      alice = Fabricate(:user) 
      expect(alice.token).to be_present
    end 
  end 

  context "#downcase_email" do 
    it "it makes the email attributes lowercase" do 
     user.email = "MYEMAIL@GMAIL.COM"
     expect{ user.downcase_email }.to change{ user.email }.
       from("MYEMAIL@GMAIL.COM").
         to("myemail@gmail.com")
    end 

    it "saves the email attributes to the database in lowercase letters" do 
      user.email = "MYEMAIL@GMAIL.COM"
      user.save 
      user.reload
      expect(user.email).to eq("myemail@gmail.com")
    end 
  end 

  context "#user_name" do 
    it "returns a users full_name as a string" do 
      expect(user.full_name).to eq "#{user.first_name} #{user.last_name}"
    end 
  end 

  context "#follows?" do 
    it "returns true if the user has a following friendship with anoth user" do  
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:friendship, leader: bob, follower: alice) 
      expect(alice.follows?(bob)).to be_truthy 
    end 
   
    it "returns false if the user doesn not have a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:friendship, leader: alice, follower: bob) 
      expect(alice.follows?(bob)).to be_falsey  
    end  
  end
end
