require 'spec_helper' 

feature 'User resets passwords' do 
  scenario 'user successfully resets password do' do  
    user = Fabricate(:user, password: 'old_password', password_confirmation: 'old_password')
    visit sign_in_path 
    click_link ' Forgot Password?'
    fill_in "Email Address", with: david.email
  end
end 
