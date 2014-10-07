require 'spec_helper' 

feature 'User followind' do 
  scenario "user follows and unfollows someone" do 
    david = Fabricate(:user)
    alice = Fabricate(:user)
    comedy = Fabricate(:category)
    futurama = Fabricate(:video, category: comedy) 
    review =  Fabricate(:review, user: alice, video: futurama)  
    sign_in david  
    click_video_on_home_page(futurama)
    click_link alice.full_name
    click_link "Follow" 
    expect(page).to have_content(alice.full_name)
    unfollows(alice)
    expect(page).not_to have_content(alice.full_name)
  end 

  def unfollows(friend)
    find("a[data-method='delete']").click
  end 
end 
