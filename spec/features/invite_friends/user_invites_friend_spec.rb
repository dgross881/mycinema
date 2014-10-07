require 'spec_helper'

feature 'User invites a friend' do 
  scenario 'user successfully invites a friend to myflix' do  
    david = Fabricate(:user)
    sign_in(david)
     
    invite_a_friend
    friend_accepts_invitation
    friend_signs_in 
    friend_should_follow(david)
    inviter_should_follow_friend(david)

    clear_email
  end

  def invite_a_friend
    click_link "Invite Friend"
    fill_in "Friend's Name", with: "Doogie Houser"
    fill_in "Friend's Email", with: "doogie@gmail.com"
    fill_in "Invite Message", with: "Please join myflix!"
    click_button "Send Invite"
    sign_out 
  end 

  def friend_accepts_invitation
    open_email "doogie@gmail.com"
    current_email.click_link "Click here to join MyFlix"
    fill_in "First Name", with: "Doogie" 
    fill_in "Last Name", with: "Houser" 
    fill_in "Email", with: "doogie@gmail.com"
    fill_in "Password", with: "foobar"
    fill_in "Password (again)", with: "foobar"
    click_button "Register" 
  end 

  def friend_signs_in
    fill_in "Email Address", with: "doogie@gmail.com"
    fill_in "Password", with: "foobar"
    click_button "Sign In"
  end 

  def friend_should_follow(user)
    click_link "Friends"
    expect(page).to have_content  user.full_name
    sign_out
  end 

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "Friends"
    expect(page).to have_content("Doogie Houser")
  end 
end 

