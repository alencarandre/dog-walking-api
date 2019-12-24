require 'rails_helper'

RSpec.describe DogWalkingService::Filter do
  context 'when does not passed upcoming flag via params' do
    it 'list all dog walking' do
      dog_walking1 = FactoryBot.create(:dog_walking, scheduled_at: 1.day.from_now)
      dog_walking2 = FactoryBot.create(:dog_walking, scheduled_at: Time.zone.now)
      dog_walking3 = FactoryBot.create(:dog_walking, scheduled_at: 1.day.ago)

      dog_walkings = described_class.(DogWalking, {})

      expect(dog_walkings.count).to eq(3)
      expect(dog_walkings).to match_array([ dog_walking1, dog_walking2, dog_walking3 ])
    end
  end

  context 'when passed upcoming flag via params' do
    before { Timecop.freeze(Time.zone.local(2500, 12, 30, 0, 0, 0, 0)) }
    after { Timecop.return }

    it 'does not list if scheduled in the past' do
      DogWalking::STATUSES.each do |status|
        FactoryBot.create(:dog_walking, scheduled_at: 1.second.ago, status: status)
        FactoryBot.create(:dog_walking, scheduled_at: 1.day.ago, status: status)
      end

      dog_walkings = described_class.(DogWalking, upcoming: true)

      expect(dog_walkings.count).to eq(0)
    end

    it 'does not list if scheduled in the future and status is finished' do
      FactoryBot.create(:dog_walking, scheduled_at: 1.second.from_now, status: :finished)
      FactoryBot.create(:dog_walking, scheduled_at: 1.day.from_now, status: :finished)

      dog_walkings = described_class.(DogWalking, upcoming: true)

      expect(dog_walkings.count).to eq(0)
    end

    it 'does not list if scheduled in then future and status is walking' do
      FactoryBot.create(:dog_walking, scheduled_at: 1.second.from_now, status: :walking)
      FactoryBot.create(:dog_walking, scheduled_at: 1.day.from_now, status: :walking)

      dog_walkings = described_class.(DogWalking, upcoming: true)

      expect(dog_walkings.count).to eq(0)
    end

    it 'does not list if scheduled now and status is finished' do
      FactoryBot.create(:dog_walking, scheduled_at: Time.zone.now, status: :finished)

      dog_walkings = described_class.(DogWalking, upcoming: true)

      expect(dog_walkings.count).to eq(0)
    end

    it 'does not list if scheduled now and status is walking' do
      FactoryBot.create(:dog_walking, scheduled_at: Time.zone.now, status: :walking)

      dog_walkings = described_class.(DogWalking, upcoming: true)

      expect(dog_walkings.count).to eq(0)
    end

    it 'list if scheduled in future and status is scheduled' do
      dog_walking1 = FactoryBot.create(:dog_walking, scheduled_at: 1.second.from_now, status: :scheduled)
      dog_walking2 = FactoryBot.create(:dog_walking, scheduled_at: 1.day.from_now, status: :scheduled)

      dog_walkings = described_class.(DogWalking, upcoming: true)

      expect(dog_walkings.count).to eq(2)
      expect(dog_walkings).to match_array([ dog_walking1, dog_walking2 ])
    end

    it 'list if scheduled now and status is scheduled' do
      dog_walking = FactoryBot.create(:dog_walking, scheduled_at: Time.zone.now, status: :scheduled)

      dog_walkings = described_class.(DogWalking, upcoming: true)

      expect(dog_walkings.count).to eq(1)
      expect(dog_walkings).to match_array([ dog_walking ])
    end
  end
end
