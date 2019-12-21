require 'rails_helper'

RSpec.describe DogSerializer do
  it 'serialize object' do
    dog = FactoryBot.create(:dog)
    serializer = described_class.new(dog)

    expect(serializer.to_h).to include(
      id: dog.id,
      name: dog.name,
      age: dog.age,
      dog_breed: {
        id: dog.dog_breed.id,
        name: dog.dog_breed.name
      }
    )
  end
end
