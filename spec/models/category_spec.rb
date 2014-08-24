require 'spec_helper'

describe Category do
  context "relationships and validations for categories" do 
    it {should have_many(:videos)}
    it {should validate_presence_of(:name) }
  end 

  describe "It will show the first 6 recent videos" do 
    let(:comedies) { Category.create(name: "comedies")} 
    let(:batman) { 
       {
        title: "Supeman", 
        description: "Staring Chirstopher Reed", 
        category: comedies, 
        created_at: 1.hour.ago 
      }
    }
    it "returns the six most recent videos" do 
      6.times { Video.create(batman) }
      superman = Video.create(title: "Superman", description: "stupid", category: comedies, created_at: 1.day.ago) 
      expect(comedies.recent_videos).to_not include(superman)
    end 
    
    it "returns all the videos if there are less than 6 videos" do 
      3.times { Video.create(batman) }
      expect(comedies.recent_videos.count).to eq(3)
    end 
    
    it "returns 6 videos if there are more than 6 videos" do 
       10.times { Video.create(batman) }
       expect(comedies.recent_videos.count).to eq(6)
    end 
  end
end  
