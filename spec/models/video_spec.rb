require 'spec_helper'

describe Video do
  context "relationships and validations for videos" do 
    it {should belong_to(:category) } 
    it {should validate_presence_of(:title) } 
    it {should validate_presence_of(:description) } 
  end 
 
  describe "Search by title" do 
    let(:superman) { Video.create(title: "Superman", description: "The superman wowweee", created_at: 1.day.ago) }
    let(:batman) { Video.create(title: "Batman", description: "Jack Nickelos as the joker", created_at: 1.hour.ago) }

    it "returns an empty array if no match was giv end" do 
      expect(Video.search_by_title("Boogers")).to eq([])
    end 

    it "returns an array of one video with the exact match" do 
      expect(Video.search_by_title("batman")).to eq([batman])
    end 
    
    it "returns an array of one video for a partial match" do 
      expect(Video.search_by_title("erman")).to eq([superman])
    end
    
    it "returns an array of all matches with ordered by created_at" do 
     expect(Video.search_by_title("man")).to eq([batman, superman]) 
    end 
    
    it "returns an empty array if searched with by empty strings" do 
     expect(Video.search_by_title("")).to eq([]) 
    end 
  end 
end 
