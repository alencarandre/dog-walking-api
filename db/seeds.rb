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
