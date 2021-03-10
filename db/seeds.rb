require "open-uri"
require 'json'
require 'nokogiri'

def line
  puts "-------------------------------------"
end

def dots
  puts "............."
end

EMOJI = ["👍", "👌", "🤙", "💪", "🙌", "👏", "🦾"].freeze

random_reviews = [
  {
    rating: 1,
    content: "Horrible, it ate my carpet when I wasn't home!"
  },
  {
    rating: 5,
    content: "I loved it, best pokemon ever!"
  },
  {
    rating: 4,
    content: "Amazing, was expecting it to be a bit better but I really enjoyed it."
  },
]

pokemon_trainers = [
  {
    email: "ash@pokemon.com",
    nickname: "Ash",
    avatar: "https://i.pinimg.com/originals/18/d9/e1/18d9e1307018dbc76750ca7d5124fccd.png"
  },
  {
    email: "gary@pokemon.com",
    nickname: "Gary",
    avatar: "https://static.wikia.nocookie.net/espokemon/images/c/cb/EP620_Gary.png"
  },
  {
    email: "brock@pokemon.com",
    nickname: "Brock",
    avatar: "https://i.pinimg.com/736x/38/22/63/3822638a08740c1236894e6ce34f5059.jpg"
  },
  {
    email: "misty@pokemon.com",
    nickname: "Misty",
    avatar: "https://sm.ign.com/ign_latam/screenshot/default/misty-pokemon-hija_bhfp.jpg"
  },

]

locations = [
  "Travessera de Gràcia, 47-49, 08021 Barcelona",
  "Carrer de Vallseca, 28, 08024 Barcelona",
  "Carrer de Joaquín Costa, 26, 08001 Barcelona",
  "Carrer del Dr. Trueta, 196, 08005 Barcelona",
  "Carrer dels Àngels, 6, 08001 Barcelona",
  "Passeig de Joan de Borbó, 9, 08003 Barcelona",
  "Carrer de Roc Boronat, 138, 08018 Barcelona",
  "Passeig de Gràcia, 92, 08008 Barcelona",
  "Moll de Sant Beltran s/n C.P, Moll de Sant Bertran, 08039 Barcelona",
  "Moll de Sant Bertran, 4, 08039 Barcelona",
  "Plaça del Mar, 1, 08002 Barcelona",
  "Carrer d'Ulldecona, 35, 08038 Barcelona"
]

puts "🕵️‍♂️ Getting pokemon's names from Yaml file"
file_path = Rails.root.join("db", "seed_pokemons.yml")
seed_file = YAML::load_file(file_path)

pokemons = []
seed_file['pokemons'].each_with_index do |pokemon, index|
  pokemons << pokemon.downcase.gsub(" ", "-")
end

puts "Pokemon's names filled ✅"

puts "Deleting database..."
Review.destroy_all
Booking.destroy_all
Pokemon.destroy_all
User.destroy_all
puts "Done deleting database ✅"

line
puts "👥 Creating trainers "

pokemon_trainers.each do |trainer|
  new_trainer = User.create!(email: trainer[:email], password: "password", nickname: trainer[:nickname])
  new_trainer_avatar = URI.open(trainer[:avatar])
  new_trainer.avatar.attach(io: new_trainer_avatar, filename: "#{new_trainer.nickname}_avatar.png", content_type: 'image/png')
  puts "Pokemon trainer #{new_trainer.nickname.capitalize} ready to battle 🙌🏻"
end

puts "👥 Done creating users ✅"
line

location_index = 0

puts "👨‍🔬 Creating new pokemons... 👩‍🔬"
pokemons.each do |pokemon_name|
  # Getting pokemon name and type
  poke_info_url = "https://pokeapi.co/api/v2/pokemon/#{pokemon_name.downcase}"

  pokemon_serialized = open(poke_info_url).read
  pokemon = JSON.parse(pokemon_serialized)

  # Go to next if it's already created
  puts "Creating *#{pokemon['species']['name'].capitalize}* 🧪"
  puts "- Type: #{pokemon['types'][0]['type']['name'].capitalize}"

  # Getting pokemon description
  poke_description_url = "https://www.pokemon.com/us/pokedex/#{pokemon['species']['name']}"

  html_file = open(poke_description_url).read
  html_doc = Nokogiri::HTML(html_file)

  pokemon_description = html_doc.search('.version-x.active')[0].text.strip

  puts "location_index: #{location_index}"
  puts "location: #{locations[location_index]}"
  # Creating new pokemon object
  new_pokemon = Pokemon.new(
    name: pokemon['species']['name'],
    description: pokemon_description,
    price: (rand(45..250)),
    location: locations[location_index],
    user: User.all.sample
  )

  location_index += 1

  pokemon['types'].each do |pokemon_type|
    new_pokemon.tag_list.add(pokemon_type['type']['name'])
  end

  puts "→ #{new_pokemon.name.capitalize} created! #{EMOJI.sample} - Total actual pokemons: #{Pokemon.count}" if new_pokemon.save!

  # Getting pokemon photo and attaching it to pokemon instance
  pokemon_id = pokemon["id"].to_s.rjust(3, "0")

  pokemon_photo_url = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/#{pokemon_id}.png"
  pokemon_photo = URI.open(pokemon_photo_url)
  new_pokemon.photo.attach(io: pokemon_photo, filename: "#{pokemon["species"]["name"]}.png", content_type: 'image/png')

  line
  sleep(3)
end

puts "Creating bookings and reviews for all pokemons"
Pokemon.all.each do |pokemon|
  start_date = Date.today - rand(45..250)
  end_date = start_date + rand(2..20)
  user = User.all.sample

  booking = Booking.create!(
    start_date: start_date,
    end_date: end_date,
    pokemon: pokemon,
    user: user
  )
  # TODO: Randomize this to be between accepted and declined
  booking.accepted!
  puts "→ Booking created: #{user.nickname.capitalize} booked #{pokemon.name.capitalize} from #{start_date} to #{end_date}."

  review = Review.new(random_reviews.sample)
  review.booking = booking
  review.save!
  puts "    → #{user.nickname.capitalize} reviewed this booking with a #{review.rating}"
  line
end

puts "Total pokemons 🐶: #{Pokemon.count}"
puts "Total users 👥: #{User.count}"
puts "Total bookings 🧾: #{Booking.count}"
puts "Total reviews 🗣: #{Review.count}"
