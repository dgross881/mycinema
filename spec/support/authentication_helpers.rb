module AuthenticationHelpers
 module Controller
   def already_signed_in
    @user ||= Fabricate(:user)
    controller.stub(:current_user).and_return @user
   end 

   def set_current_admin(admin=nil)
     session[:user_id] = (admin || Fabricate(:admin)).id
   end 
 end 
end 
