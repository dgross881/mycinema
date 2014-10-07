require 'spec_helper' 

feature 'User resets passwords' do 
  scenario 'user successfully resets password do' do  
    david = Fabricate(:user, password: 'old_password', password_confirmation: 'old_password')
    visit sign_in_path 
    click_link 'Forgot Password'
    fill_in "Email Address", with: david.email
    click_button "Send Email"

    open_email(david.email)
    current_email.click_link('Reset My Password')

    fill_in "New Password", with: "new_password" 
    fill_in "Password (again)", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: david.email
    fill_in "Password", with: "new_password"
    click_button "Sign In"
    expect(page).to have_content("Welcome, #{david.full_name}")
  end
end 
