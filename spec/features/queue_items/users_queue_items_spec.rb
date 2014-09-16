require 'spec_helper' 

feature "Users queue items" do 
  scenario "Signed in user can add queue_items" do 
    comedy = Fabricate(:category)
    southpark = Fabricate(:video, title: "southpark", category: comedy) 
    futurama = Fabricate(:video, title: "futurama", category: comedy) 
    familyguy = Fabricate(:video, title: "family guy", category: comedy)
    user = Fabricate(:user)
    sign_in user  
    find("a[href='/videos/#{southpark.id}']").click
    expect(page).to have_content(southpark.title)
    
    click_link "+ My Queues" 
    expect(page).to have_content("#{southpark.title} was successfully added to your queue")
    
    visit video_path(southpark)
    expect(page).to_not have_content "+ My Queues"

    visit home_path 
    find("a[href='/videos/#{futurama.id}']").click
    click_link "+ My Queues" 
    visit home_path 
    find("a[href='/videos/#{familyguy.id}']").click
    click_link "+ My Queues" 
  end 
end  
