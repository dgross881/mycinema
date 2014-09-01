# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
comedies = Category.create(name: "Comedies")
dramas = Category.create(name: "Dramas") 

Video.create(title: 'Monk', description: 'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: dramas )
Video.create(title: 'Family Guy', description: 'In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '',  category: comedies )
Video.create(title: 'Futurama', description: "Fry, a pizza guy is accidentally frozen in 999 and thawed out New Year's Eve 999.", small_cover_url: '/tmp/futurama.jpg', large_cover_url: '',  category: comedies)
south_park = Video.create(title: 'South Park', description: 'Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.', small_cover_url: '/tmp/south_park.jpg', large_cover_url: '', category: comedies)
Video.create(title: 'Monk', description: 'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg',  category: dramas)
Video.create(title: 'Family Guy', description: 'In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '',  category: comedies)

david = User.create(first_name: "David", last_name: "Gross", email: "foobar@gmail.com", password: "foobar", password_confirmation: "foobar") 
Review.create(user: david, video: south_park, rating: 4, content: "This was an awesome tv series very funny", created_at: 1.day.ago)
Review.create(user: david, video: south_park, rating: 2, content: "The movies was not as good as the tv show ", created_at: 1.hour.ago)
