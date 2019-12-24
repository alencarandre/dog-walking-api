require 'rails_helper'

RSpec.describe DogWalking, type: :model do
  context 'validations' do
    it { should validate_presence_of(:pets) }
    it { should validate_presence_of(:scheduled_at) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:price) }


    it 'validates presence of final_price if status is finished' do
      subject.status = :finished

      should validate_presence_of(:final_price)
    end

    it 'validates presence of final_price if status is finished' do
      %i(scheduled walking).each do |status|
        subject.status = status

        should_not validate_presence_of(:final_price)
      end
    end

    it 'accepts valid status' do
      DogWalking::STATUSES.each do |status|
        expect(FactoryBot.build(:dog_walking, status: status)).to be_valid
      end
    end

    it 'does not accept invalid status' do
      %i(invalid status here).each do |status|
        expect(FactoryBot.build(:dog_walking, status: status)).to_not be_valid
      end
    end
  end

  context 'associations' do
    it { is_expected.to have_many(:dog_walking_dogs) }
    it { is_expected.to have_many(:pets).through(:dog_walking_dogs) }
  end

  context 'scopes' do
    describe '#by_status' do
      let(:dog_walking_scheduled) { FactoryBot.create(:dog_walking, status: :scheduled) }
      let(:dog_walking_walking) { FactoryBot.create(:dog_walking, status: :walking) }
      let(:dog_walking_finished) { FactoryBot.create(:dog_walking, status: :finished) }

      it 'returns dog walking with scheduled status' do
        expect(DogWalking.by_status(:scheduled)).to match_array([ dog_walking_scheduled ])
      end

      it 'returns dog walking with walking status' do
        expect(DogWalking.by_status(:walking)).to match_array([ dog_walking_walking ])
      end

      it 'returns dog walking with finished status' do
        expect(DogWalking.by_status(:finished)).to match_array([ dog_walking_finished ])
      end

      it 'return dog_walking searched using more than one status' do
        expect(DogWalking.by_status(:finished, :scheduled))
          .to match_array([ dog_walking_scheduled, dog_walking_finished ])

        expect(DogWalking.by_status(:walking, :finished))
          .to match_array([ dog_walking_walking, dog_walking_finished ])

        expect(DogWalking.by_status(:scheduled, :walking, :finished))
          .to match_array([ dog_walking_scheduled, dog_walking_walking, dog_walking_finished ])
      end
    end

    describe '#scheduled_higher_or_equal' do
      let!(:dog_walking_now) { FactoryBot.create(:dog_walking, scheduled_at: Time.zone.now) }
      let!(:dog_walking_tomorrow) { FactoryBot.create(:dog_walking, scheduled_at: 1.day.from_now) }
      let!(:dog_walking_yesterday) { FactoryBot.create(:dog_walking, scheduled_at: 1.day.ago) }

      it 'returns dog walkings scheduled from passed time' do
        expect(DogWalking.scheduled_higher_or_equal(Time.zone.now.beginning_of_day))
          .to match_array([ dog_walking_now, dog_walking_tomorrow ])

        expect(DogWalking.scheduled_higher_or_equal(1.day.from_now.beginning_of_day))
          .to match_array([ dog_walking_tomorrow ])

        expect(DogWalking.scheduled_higher_or_equal(1.day.ago.beginning_of_day))
          .to match_array([ dog_walking_now, dog_walking_tomorrow, dog_walking_yesterday ])
      end
    end
  end

  context 'state machine' do
    it { is_expected.to transition_from(:scheduled).to(:walking).on_event(:start_walking) }
    it { is_expected.to transition_from(:walking).to(:finished).on_event(:finish_walking) }

    it 'set started_at to now when start walking' do
      Timecop.freeze(Time.zone.local(2500, 12, 30, 0, 0, 0, 0)) do
        subject = FactoryBot.create(:dog_walking, status: :scheduled, started_at: nil)

        expect { subject.start_walking }
          .to change { subject.started_at }
          .from(nil)
          .to(Time.zone.now)
      end
    end

    it 'set finished_at to now when finish walking' do
      Timecop.freeze(Time.zone.local(2500, 12, 30, 0, 0, 0, 0)) do
        subject = FactoryBot.create(:dog_walking, status: :walking, finished_at: nil)

        expect { subject.finish_walking }
          .to change { subject.finished_at }
          .from(nil)
          .to(Time.zone.now)
      end
    end
  end
end
