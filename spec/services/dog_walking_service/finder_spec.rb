require 'rails_helper'

RSpec.describe DogWalkingService::Finder do
  it 'raise error if passed id does not exists on database' do
    expect { described_class.(DogWalking, id: 999) }
      .to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns found dog walking if passed id' do
    dog_walking = FactoryBot.create(:dog_walking)

    expect(described_class.(DogWalking, id: dog_walking.id))
      .to eq(dog_walking)
  end
end
