require "ffaker" 

Fabricator(:video) do 
  title { Faker::Lorem.words(6) }
  description { Faker::Lorem.paragraph(2) } 
end 

Fabricator(:category) do
  name { "comedies" }
end 
