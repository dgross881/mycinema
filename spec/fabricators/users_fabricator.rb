require 'ffaker'
Fabricator(:user) do 
  first_name { Faker::Name.first_name } 
  last_name  { Faker::Name.last_name }
  email { Faker::Internet.email } 
  password { "foobar"}
  password_confirmation { "foobar" } 
end 

Fabricator(:category) do
  name { "comedies" }
end 

Fabricator(:video) do 
  title { Faker::Lorem.words(6) }
  description { Faker::Lorem.paragraph(2) } 
end 






