require 'rails_helper'

RSpec.describe DogWalkingDecorator do
  describe '#scheduled_at' do
    it 'return formated datetime' do
      Timecop.freeze(Time.zone.local(2500, 12, 30, 15, 45, 07)) do
        subject = FactoryBot
          .build(:dog_walking, scheduled_at: Time.zone.now)
          .decorate

        expect(subject.scheduled_at).to eq('2500-12-30 15:45:07')
      end
    end
  end

  describe '#started_at' do
    it 'return formated datetime' do
      Timecop.freeze(Time.zone.local(2500, 11, 30, 15, 45, 07)) do
        subject = FactoryBot
          .build(:dog_walking, started_at: Time.zone.now)
          .decorate

        expect(subject.started_at).to eq('2500-11-30 15:45:07')
      end
    end
  end

  describe '#finished_at' do
    it 'return formated datetime' do
      Timecop.freeze(Time.zone.local(2500, 10, 30, 15, 45, 07)) do
        subject = FactoryBot
          .build(:dog_walking, finished_at: Time.zone.now)
          .decorate

        expect(subject.finished_at).to eq('2500-10-30 15:45:07')
      end
    end
  end

  describe '#real_duration' do
    it 'returns nil if finished_at is undefined' do
      subject = FactoryBot
        .build(:dog_walking, finished_at: nil)
        .decorate

      expect(subject.real_duration).to be_nil
    end

    it 'returns calculated duration in minutes if finished_at is defined' do
      Timecop.freeze(Time.zone.local(2500, 12, 30, 00, 00, 00)) do
        subject = FactoryBot
          .build(:dog_walking, started_at: 10.minutes.ago, finished_at: Time.zone.now)
          .decorate

        expect(subject.real_duration).to eq(10)
      end
    end
  end
end
