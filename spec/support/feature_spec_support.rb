def sign_in(a_user=nil)
   user = a_user || Fabricate(:user) 
   visit root_path 
   click_link "Sign In" 
   fill_in "Email", with: user.email
   fill_in "Password", with: user.password
   click_button "Sign In" 
end 

def sign_out
  visit sign_out_path
end 


def click_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end 
