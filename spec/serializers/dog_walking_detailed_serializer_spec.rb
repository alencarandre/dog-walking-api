require 'rails_helper'

RSpec.describe DogWalkingDetailedSerializer do
  it 'serialize object' do
    dog1 = FactoryBot.create(:dog)
    dog2 = FactoryBot.create(:dog)
    dog_walking = FactoryBot
      .create(
        :dog_walking,
        pets: [ dog1, dog2 ]
      )
    serializer = described_class.new(dog_walking)

    expect(serializer.to_h).to include(
      id: dog_walking.id,
      status: dog_walking.status,
      duration: dog_walking.duration,
      real_duration: dog_walking.decorate.real_duration,
      price: dog_walking.price,
      latitude: dog_walking.latitude,
      longitude: dog_walking.longitude,
      scheduled_at: dog_walking.decorate.scheduled_at,
      started_at: dog_walking.decorate.started_at,
      finished_at: dog_walking.decorate.finished_at,
      pets: [
        {
          id: dog1.id,
          name: dog1.name,
          age: dog1.age,
          dog_breed: {
            id: dog1.dog_breed.id,
            name: dog1.dog_breed.name
          }
        }, {
          id: dog2.id,
          name: dog2.name,
          age: dog2.age,
          dog_breed: {
            id: dog2.dog_breed.id,
            name: dog2.dog_breed.name
          }
        }
      ]
    )
  end
end
