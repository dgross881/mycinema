require 'spec_helper' 

describe User do
    let(:user) { User.new(
                 first_name: "Bob", 
                 last_name: "Builder", 
                 email: "MYEMAIL@GMAIL.COM",
                 password: "foobar",
                 password_confirmation: "foobar") }
   
 context "Valid attributes for users" do  
   it { should validate_presence_of(:email) }
   it { should validate_uniqueness_of(:email) } 

   it "must be a verified email address" do 
     user.email = "Thisisnoemail" 
     expect(user).to_not be_valid 
   end 
 end 

 context "#downcase_email" do 
  it "it makes the email attributes lowercase" do 
   expect{ user.downcase_email }.to change{ user.email }.
     from("MYEMAIL@GMAIL.COM").
     to("myemail@gmail.com")
  end 

  it "saves the email attributes to the database in lowercase letters" do 
   user.save 
   user.reload
   expect(user.email).to eq("myemail@gmail.com")
  end 
 end 

  context "#user_name" do 
   it "returns a users full_name as a string" do 
     expect(user.name).to eq "Bob Builder" 
  end 
 end 
end
