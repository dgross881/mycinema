require 'spec_helper' 

feature "Users queue items" do 
  scenario "Signed in user can add queue_items" do 
    comedy = Fabricate(:category)
    southpark = Fabricate(:video, title: "southpark", category: comedy) 
    futurama = Fabricate(:video, title: "futurama", category: comedy) 
    familyguy = Fabricate(:video, title: "family guy", category: comedy)
    user = Fabricate(:user)
    sign_in user  
    
    add_video_to_queue(southpark)
    expect(page).to have_content("#{southpark.title} was successfully added to your queue")
    
    visit video_path(southpark)
    expect(page).to_not have_content "+ My Queues"

    add_video_to_queue(futurama)
    add_video_to_queue(familyguy)

    set_video_position(familyguy, 2)
    set_video_position(southpark, 3)
    set_video_position(futurama, 1)
    
    click_button "Update Instant Queue"
    
    expect(user.queue_items.first.video_id).to eq(futurama.id) 
    expect(user.queue_items.second.video_id).to eq(familyguy.id)
    expect(user.queue_items.third.video_id).to eq(southpark.id)
  end 
end 
  
  def set_video_position(video, position)
    within dom_id_for video do
      fill_in "queue_items[][position]", with: position 
    end 
  end 
  
  def add_video_to_queue(video)
    visit home_path 
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queues" 
  end 
  
  #expect(find(:xpath, "//tr[contains(.,'#{southpark.title}')]//input[@type= 'text']").value).to eq("3")
 
