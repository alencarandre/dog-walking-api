require 'rails_helper'

RSpec.describe DogWalkingSerializer do
  it 'serialize object' do
    dog_walking = FactoryBot.create(:dog_walking)
    serializer = described_class.new(dog_walking)

    expect(serializer.to_h).to include(
      id: dog_walking.id,
      status: dog_walking.status,
      duration: dog_walking.duration,
      price: dog_walking.price,
      scheduled_at: dog_walking.decorate.scheduled_at,
      started_at: dog_walking.decorate.started_at,
      finished_at: dog_walking.decorate.finished_at,
      pets: dog_walking.pets.count
    )
  end
end
