require 'spec_helper' 

feature "User signs up" do 
  scenario "Allows user to sign up for the site" do 
    expect(User.count).to eq 0  
    visit root_path 
    click_link "Sign Up Now!"
    fill_in "First Name", with: "Foo" 
    fill_in "Last Name", with: "Bar" 
    fill_in "Email", with: "foobar@gmail.com"
    fill_in "Password", with: "foobar"
    fill_in "Password (again)", with: "foobar"
    click_button "Register" 
    expect(User.count).to eq 1
    expect(page).to have_content "You are now signed up, Please login"
  end 
end 
  
