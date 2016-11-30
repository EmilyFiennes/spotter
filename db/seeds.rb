Event.destroy_all
Activity.destroy_all
User.destroy_all

# 20 real addresses in Bordeaux
event_addresses = ["107 Cours Balguerie Stuttenberg, Bordeaux", "73 Rue Leyteire, Bordeaux", "19 Rue Lagrange, Bordeaux", "82 Rue du Palais Gallien, Bordeaux", "72 Rue Fondaudège, Bordeaux", "15 Rue Goya, Bordeaux", "287 Rue Georges Bonnac, Bordeaux", "42 Cours de l'Argonne, Bordeaux", "16 Rue Guépin, Bordeaux", "54 Rue de Dijon, Bordeaux"]
user_addresses = ["97 Rue Hortense, Bordeaux", "61 Rue de Libourne, Bordeaux", "36 Rue Surson, Bordeaux", "206 Avenue Victor Hugo, Le Bouscat", "19 Allée Ganda, Bordeaux", "51 Rue Mac Carthy, Bordeaux", "49 Rue Paul Doumer, Merignac", "59 Rue Boutin, Bordeaux", "41 Rue de Pessac, Bordeaux", "61 Rue du Pas-Saint-Georges, Bordeaux"]

# 20 real activities
activity_names = ["Swimming", "Running", "Bowling", "Rugby", "Soccer", "Tennis", "Badminton", "Basketball", "Biking", "Roller"]

# 5 fake descriptions
descriptions = ["Looking for cool mates to practice!", "Let's gather together and kick our butt", "Join me and have some fun", "I'm new in this city and looking for sport buddies", "I've been a coach for 5 years and I'm here to make you a champion"]

# Faker
first_name_girl = ["Audrey", "Emily", "Jane", "Alice", "Barbara", "Sophie", "Kate", "Doris", "Janice"]
first_name_boy = ["Seb", "Mathieu", "Johnny", "Paul", "Henry", "Steve", "Brian", "James", "Horace"]

# 3 levels
levels = ["newbie","intermediate","champion"]

# 10 fake portraits
picture_girl = [
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502820/g-vaiana_ubjgxr.jpg",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502853/g-savannah_jquuus.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502832/g-orsi_wlxigm.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502860/g-nur_izbrhy.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502871/g-morgane_e6nmzo.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502851/g-lea_dgwic4.jpg",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502823/g-charlotte_sfakvi.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502808/g-chantal_lfuod2.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502868/g-camille_modmk8.png"
]
picture_boy = ["http://res.cloudinary.com/dfexzh84z/image/upload/v1480502816/b-rudy_krnz6j.jpg",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502785/b-pierre_ppcfzm.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502704/b-laurent_phj33i.jpg",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502849/b-jimmy_hzwbmy.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502798/b-edouard_fcii8r.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502743/b-benoit_wdhv4n.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502783/b-arnaud_gvtkzi.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502759/b-antoine2_pdtr77.png",
  "http://res.cloudinary.com/dfexzh84z/image/upload/v1480502689/b-antoine1_qxkv9r.jpg"
]

# Generating 20 activities
activities = []
activity_names.each do |activity_name|
  activities << Activity.create(
  name: activity_name
  )
end

users = [] # Generating 10 users (girls)
9.times do
  last_name = Faker::Name.last_name
  first_name = first_name_girl.sample
  users <<  User.create(
    first_name: first_name,
    last_name: last_name,
    password: "secret",
    address: user_addresses.sample,
    bio: Faker::StarWars.quote,
    facebook_picture_url: picture_girl.shift,
    gender: "woman",
    email: "#{first_name}.#{last_name}@gmail.com",
    #facebook_messenger_psid:
  )
end

# Generating 10 users (boys)

9.times do
  last_name = Faker::Name.last_name
  first_name = first_name_boy.sample
  users << User.create(
    first_name: first_name,
    last_name: last_name,
    password: "secret",
    address: user_addresses.sample,
    bio: Faker::StarWars.quote,
    facebook_picture_url: picture_boy.shift,
    gender: "man",
    email: "#{first_name}.#{last_name}@gmail.com",
    #facebook_messenger_psid:
  )
end


# Generating 20 events
20.times do
  Event.create(
    start_at: DateTime.now + (0..5).to_a.sample,
    end_at: DateTime.now + (6..10).to_a.sample,
    address: event_addresses.sample,
    user: users.sample,
    description: descriptions.sample,
    #cancelled_at:
    level: levels.sample,
    activity: activities.sample,
    max_participants: (1..6).to_a.sample
  )
end

# Generating 40 participations
40.times do
  user = users.sample
  event = Event.where.not(user: user).sample
  unless event.participants.count >= event.max_participants && event.participants.include?(user)
    Participation.create(
      user: user,
      event: event
      )
  end
end

print "seed complete"
