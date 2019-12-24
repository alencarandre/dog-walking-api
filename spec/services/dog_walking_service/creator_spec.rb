require 'rails_helper'

RSpec.describe DogWalkingService::Creator do
  context 'when pass invalid parameters' do
    let!(:invalid_parameter) do
      {
        latitude: nil,
        longitude: nil,
        duration: nil,
        scheduled_at: nil,
        started_at: nil,
        finished_at: nil,
        pet_ids: []
      }
    end

    it 'does not persist dog walking' do
      expect { described_class.(DogWalking, invalid_parameter) }
        .to_not change { DogWalking.count }
    end

    it 'returns invalid object' do
      expect(described_class.(DogWalking, invalid_parameter))
        .to_not be_valid
    end
  end

  context 'when does not pass pets' do
    let!(:params_without_pet) do
      {
        latitude: 158.5555,
        longitude: 257.7896,
        duration: 30,
        scheduled_at: 1.day.from_now,
        started_at: nil,
        finished_at: nil,
        pet_ids: []
      }
    end

    it 'does not persist dog walking' do
      expect { described_class.(DogWalking, params_without_pet) }
        .to_not change { DogWalking.count }
    end

    it 'returns invalid object' do
      expect(described_class.(DogWalking, params_without_pet))
        .to_not be_valid
    end
  end

  context 'when pass valid parameters' do
    let(:dog1) { FactoryBot.create(:dog) }
    let(:dog2) { FactoryBot.create(:dog) }
    let(:valid_parameter) do
      {
        latitude: 158.5555,
        longitude: 257.7896,
        duration: 30,
        scheduled_at: 1.day.from_now,
        started_at: nil,
        finished_at: nil,
        pet_ids: [ dog1.id, dog2.id ]
      }
    end

    before { FactoryBot.create(:table_price, price: 1, price_additional: 2) }

    it 'persist object' do
      expect { described_class.(DogWalking, valid_parameter) }
        .to change { DogWalking.count }
        .by(1)
    end

    it 'returns a valid object' do
      expect(described_class.(DogWalking, valid_parameter))
        .to be_valid
    end

    it 'save nested pets' do
      dog_walking = described_class.(DogWalking, valid_parameter)

      expect(dog_walking.pets)
        .to match_array([ dog1, dog2 ])
    end

    it 'set status to scheduled' do
      dog_walking = described_class.(DogWalking, valid_parameter)

      expect(dog_walking.status).to eq(:scheduled)
    end

    it 'calculate estimate price' do
      dog_walking = described_class.(DogWalking, valid_parameter)

      expect(dog_walking.price).to eq(3)
    end
  end
end
