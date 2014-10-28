require 'ffaker'
Fabricator(:user) do 
  first_name { Faker::Name.first_name } 
  last_name  { Faker::Name.last_name }
  email { Faker::Internet.email } 
  password { "foobar"}
  password_confirmation { "foobar" } 
end 

Fabricator(:admin, from: :user) do 
 admin true 
end 









