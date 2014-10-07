module AuthenticationHelpers
 module Controller
   def already_signed_in
    @user ||= Fabricate(:user)
    controller.stub(:current_user).and_return @user
   end 
 end 
end 
