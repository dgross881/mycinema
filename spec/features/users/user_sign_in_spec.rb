require 'spec_helper'

feature 'User signs in' do 
  background do 
    @user = Fabricate(:user)  
  end 

  scenario "User can sign in" do 
    visit root_path
    click_link 'Sign In'
    fill_in "Email Address", with: @user.email
    fill_in "Password", with: @user.password 
    click_button "Sign In" 
    expect(page).to have_content("Welcome, #{@user.full_name}")
  end 
end 
