Event.destroy_all
Activity.destroy_all
User.destroy_all

# 20 real addresses in Bordeaux
event_addresses = ["107 Cours Balguerie Stuttenberg, Bordeaux", "73 Rue Leyteire, Bordeaux", "19 Rue Lagrange, Bordeaux", "82 Rue du Palais Gallien, Bordeaux", "72 Rue Fondaudège, Bordeaux", "15 Rue Goya, Bordeaux", "287 Rue Georges Bonnac, Bordeaux", "42 Cours de l'Argonne, Bordeaux", "16 Rue Guépin, Bordeaux", "54 Rue de Dijon, Bordeaux"]
user_addresses = ["97 Rue Hortense, Bordeaux", "61 Rue de Libourne, Bordeaux", "36 Rue Surson, Bordeaux", "206 Avenue Victor Hugo, Le Bouscat", "19 Allée Ganda, Bordeaux", "51 Rue Mac Carthy, Bordeaux", "49 Rue Paul Doumer, Merignac", "59 Rue Boutin, Bordeaux", "41 Rue de Pessac, Bordeaux", "61 Rue du Pas-Saint-Georges, Bordeaux"]

# 20 real activities
activity_names = ["Swimming", "Running", "Bowling", "Rugby", "Soccer", "Tennis", "Petanque", "Badminton", "Basketball", "Biking", "Climbing", "Golf", "Hiking", "Roller", "Squash", "Surfing", "Skating", "Volley", "Workout", "Skiing"]

# 5 fake descriptions
descriptions = ["Looking for cool mates to practice!", "Let's gather together and kick our butt", "Join me and have some fun", "I'm new in this city and looking for sport buddies", "I've been a coach for 5 years and I'm here to make you a champion"]

# Faker
first_name_girl = ["Audrey", "Emily", "Jane", "Alice", "Barbara"]
first_name_boy = ["Seb", "Mathieu", "Johnny", "Paul", "Henry"]

# 3 levels
levels = ["newbie","intermediate","champion"]

# 10 fake portraits
picture_girl = ["https://cdn.pixabay.com/photo/2015/09/02/13/24/girl-919048_640.jpg", "http://vignette1.wikia.nocookie.net/camphalfbloodroleplay/images/4/4b/Photo_33.jpg/revision/latest?cb=20131216021409", "https://pbs.twimg.com/profile_images/674428042626908160/CbBgASTK.jpg", "https://whitmanstars.files.wordpress.com/2013/02/screen-shot-2013-02-07-at-10-14-08-pm.png", "http://www.legorafi.fr/wp-content/uploads/2013/04/iStock_000011434000XSmall.jpg"]
picture_boy = ["https://scontent.cdninstagram.com/hphotos-xap1/t51.2885-15/e15/11055705_1413935155580535_1015724446_n.jpg", "http://msnbcmedia.msn.com/j/MSNBC/Components/Photo/_new/120611-Rathmann-vsmall.380;380;7;70;0.jpg", "http://blog.prestonmerchant.com/.a/6a00d8354c461f69e2013485fdc1c2970c-pi", "http://actorstheatre.org/wp-content/uploads/2012/12/Michael-Whatley-Headshot-1024x682.jpg", "http://www.personal-sport-trainer.com/blog/wp-content/uploads/2013/02/coach-sportif-toulouse1.jpg"]

# Generating 20 activities
activities = []
20.times do
  activities << Activity.create(
  name: activity_names.sample
  )
end

users = [] # Generating 5 users (girls)
5.times do
  last_name = Faker::Name.last_name
  first_name = first_name_girl.sample
  users <<  User.create(
    first_name: first_name,
    last_name: last_name,
    password: "secret",
    address: user_addresses.sample,
    bio: Faker::StarWars.quote,
    gender: "woman",
    email: "#{first_name}.#{last_name}@gmail.com",
    #facebook_messenger_psid:
  )
end

# Generating 5 users (boys)

5.times do
  last_name = Faker::Name.last_name
  first_name = first_name_boy.sample
  users << User.create(
    first_name: first_name,
    last_name: last_name,
    password: "secret",
    address: user_addresses.sample,
    bio: Faker::StarWars.quote,
    gender: "man",
    email: "#{first_name}.#{last_name}@gmail.com",
    #facebook_messenger_psid:
  )
end


# Generating 10 events
10.times do
  event = Event.new(
    start_at: Date.today + (0..5).to_a.sample,
    end_at: Date.today + (6..10).to_a.sample,
    address: event_addresses.sample,
    user: users.sample,
    description: descriptions.sample,
    #cancelled_at:
    level: levels.sample,
    activity: activities.sample,
    max_participants: (1..6).to_a.sample
  )
  event.save
end


print "seed complete"
