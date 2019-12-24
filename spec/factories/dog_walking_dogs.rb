FactoryBot.define do
  factory :dog_walking_dog do
    dog

    after(:build) do |dog_walking_dog|
      if dog_walking_dog.dog_walking.blank?
        dog_walking_dog.dog_walking = FactoryBot.build(:dog_walking, dog_walking_dogs: [dog_walking_dog])
      end
    end
  end
end
