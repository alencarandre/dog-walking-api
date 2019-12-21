FactoryBot.define do
  factory :dog do
    name { Faker::Cosmere.aon }
    breed { :saint_bernard }
    age { 1 }

    dog_breed
  end
end
