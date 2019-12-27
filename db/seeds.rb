# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

['Bulldog', 'Beagle', 'Boxer', 'Chow Chow', 'Dalmatian'].each do |breed|
  DogBreed.where(name: breed).first_or_create!
end

breeds = DogBreed.all
['Coockie', 'Lilica', 'Boris', 'Laica', 'Morgana'].each do |dog|
  Dog.where(name: dog)
    .first_or_create!(
      dog_breed: breeds.sample,
      age: (0..10).to_a.sample
    )
end

TablePrice.where(cadence: 30).first_or_create!(price: 25.0, price_additional: 15.0)
TablePrice.where(cadence: 60).first_or_create!(price: 35.0, price_additional: 20.0)

(1..3).each do |i|
  pets = Dog.all.sample((1..3).to_a.sample).pluck(:id)
  DogWalking.create!(
    status: :scheduled,
    duration: 30,
    price: DogWalkingService::PriceCalculator.(duration: 30, pets: pets.length),
    scheduled_at: (i-1).days.from_now,
    latitude: 100.9999,
    longitude: 200.5555,
    pet_ids: pets
  )
end

pets = Dog.all.sample((1..3).to_a.sample).pluck(:id)
DogWalking.create!(
  status: :walking,
  duration: 30,
  price: DogWalkingService::PriceCalculator.(duration: 30, pets: pets.length),
  scheduled_at: 1.days.ago,
  latitude: 100.9999,
  longitude: 200.5555,
  started_at: 1.days.ago,
  pet_ids: pets
)

(1..3).each do |i|
  pets = Dog.all.sample((1..3).to_a.sample).pluck(:id)
  DogWalking.create!(
    status: :finished,
    duration: 30,
    price: DogWalkingService::PriceCalculator.(duration: 30, pets: pets.length),
    final_price: 2,
    scheduled_at: i.days.ago,
    latitude: 100.9999,
    longitude: 200.5555,
    started_at: i.days.ago,
    finished_at: i.days.ago + (30..60).to_a.sample.minutes,
    pet_ids: pets
  )
end
