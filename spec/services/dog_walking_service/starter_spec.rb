require 'rails_helper'

RSpec.describe DogWalkingService::Starter do
  before { Timecop.freeze(Time.zone.local(2500, 12, 30, 0, 0, 0, 0)) }
  after { Timecop.return }

  describe 'when has passed nonexistent dog_walking' do
    it 'raise error' do
      expect { described_class.(DogWalking, id: 999) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'when has passed existent dog_walking' do
    it 'set started_at to now' do
      dog_walking = FactoryBot.create(:dog_walking, status: :scheduled)

      described_class.(DogWalking, id: dog_walking.id)

      expect(dog_walking.reload.started_at).to eq(Time.zone.now)
    end

    it 'set status to :walking' do
      dog_walking = FactoryBot.create(:dog_walking, status: :scheduled)

      described_class.(DogWalking, id: dog_walking.id)

      expect(dog_walking.reload.status).to eq(:walking)
    end

    it 'set object errors if has already started walking' do
      dog_walking = FactoryBot.create(:dog_walking, status: :walking)

      object = described_class.(DogWalking, id: dog_walking.id)

      expect(object.errors.full_messages)
        .to be_present
        .and match_array([ "Status Event 'start_walking' cannot transition from 'walking'." ])
    end
  end
end
