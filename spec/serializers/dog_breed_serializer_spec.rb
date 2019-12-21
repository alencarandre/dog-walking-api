require 'rails_helper'

RSpec.describe DogBreedSerializer do
  it 'serialize object' do
    dog_breed = FactoryBot.create(:dog_breed)
    serializer = described_class.new(dog_breed)

    expect(serializer.to_h).to include(
      id: dog_breed.id,
      name: dog_breed.name
    )
  end
end
