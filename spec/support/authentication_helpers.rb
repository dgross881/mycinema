module AuthenticationHelpers
 module Controller 
   def sign_in(user)
    @user ||= Fabricate.build :user
    controller.stub(:current_user).and_return(@user)
   end 
 end 
end 
