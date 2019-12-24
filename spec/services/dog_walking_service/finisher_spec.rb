require 'rails_helper'

RSpec.describe DogWalkingService::Finisher do
  before { Timecop.freeze(Time.zone.local(2500, 12, 30, 0, 0, 0, 0)) }
  after { Timecop.return }

  describe 'when has passed nonexistent dog_walking' do
    it 'raise error' do
      expect { described_class.(DogWalking, id: 999) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'when has passed existent dog_walking' do
    before { FactoryBot.create(:table_price, cadence: 60, price: 2, price_additional: 1) }

    it 'set finished_at to now' do
      dog_walking = FactoryBot.create(:dog_walking, :walking)

      described_class.(DogWalking, id: dog_walking.id)

      expect(dog_walking.reload.finished_at).to eq(Time.zone.now)
    end

    it 'set status to finished if transition is correct' do
      dog_walking = FactoryBot.create(:dog_walking, :walking)

      described_class.(DogWalking, id: dog_walking.id)

      expect(dog_walking.reload.status).to eq(:finished)
    end

    it 'calculate final price if transition is correct' do
      dog1 = FactoryBot.create(:dog)
      dog2 = FactoryBot.create(:dog)
      dog_walking = FactoryBot
        .create(
          :dog_walking,
          :walking,
          duration: 30,
          started_at: 60.minutes.ago,
          finished_at: Time.zone.now,
          final_price: nil,
          pet_ids: [ dog1.id, dog2.id ]
        )

      described_class.(DogWalking, id: dog_walking.id)

      expect(dog_walking.reload.final_price).to eq(3)
    end

    it 'set model errors if try invalid transition' do
      %i(finished scheduled).each do |status|
        dog_walking = FactoryBot.create(:dog_walking, status: status)

        object = described_class.(DogWalking, id: dog_walking.id)

        expect(object.errors.full_messages)
          .to be_present
          .and match_array([ "Status Event 'finish_walking' cannot transition from '#{status}'." ])
      end
    end
  end
end
