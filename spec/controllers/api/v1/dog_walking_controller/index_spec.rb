require 'rails_helper'

RSpec.describe Api::V1::DogWalkingController, type: :controller do
  describe '#index' do
    context 'when flag upcoming is not passed' do
      it 'list all dog walking' do
        dog_walking1 = FactoryBot.create(:dog_walking, scheduled_at: 1.day.from_now)
        dog_walking2 = FactoryBot.create(:dog_walking, scheduled_at: Time.zone.now)
        dog_walking3 = FactoryBot.create(:dog_walking, scheduled_at: 1.day.ago)

        get :index
        dog_walkings = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(dog_walkings.count).to eq(3)
        expect(dog_walkings).to eq([{
          'id' => dog_walking1.id,
          'status' => dog_walking1.status,
          'duration' => dog_walking1.duration,
          'price' => dog_walking1.price,
          'scheduled_at' => dog_walking1.decorate.scheduled_at,
          'started_at' => dog_walking1.decorate.started_at,
          'finished_at' => dog_walking1.decorate.finished_at,
          'pets' => dog_walking1.pets.count
        }, {
          'id' => dog_walking2.id,
          'status' => dog_walking2.status,
          'duration' => dog_walking2.duration,
          'price' => dog_walking2.price,
          'scheduled_at' => dog_walking2.decorate.scheduled_at,
          'started_at' => dog_walking2.decorate.started_at,
          'finished_at' => dog_walking2.decorate.finished_at,
          'pets' => dog_walking2.pets.count
        }, {
          'id' => dog_walking3.id,
          'status' => dog_walking3.status,
          'duration' => dog_walking3.duration,
          'price' => dog_walking3.price,
          'scheduled_at' => dog_walking3.decorate.scheduled_at,
          'started_at' => dog_walking3.decorate.started_at,
          'finished_at' => dog_walking3.decorate.finished_at,
          'pets' => dog_walking3.pets.count
        }])
      end
    end

    context 'when flag upcoming is passed' do
      before { Timecop.freeze(Time.zone.local(2500, 12, 30, 0, 0, 0, 0)) }
      after { Timecop.return }

      it 'does not list if scheduled in the past' do
        DogWalking::STATUSES.each do |status|
          FactoryBot.create(:dog_walking, status: status, scheduled_at: 1.second.ago)
          FactoryBot.create(:dog_walking, status: status, scheduled_at: 1.day.ago)
        end

        get :index, params: { upcoming: true }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'does not list if scheduled in the future and status is finished' do
        FactoryBot.create(:dog_walking, :finished, scheduled_at: 1.second.from_now)
        FactoryBot.create(:dog_walking, :finished, scheduled_at: 1.day.from_now)

        get :index, params: { upcoming: true }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'does not list if scheduled in then future and status is walking' do
        FactoryBot.create(:dog_walking, :walking, scheduled_at: 1.second.from_now)
        FactoryBot.create(:dog_walking, :walking, scheduled_at: 1.day.from_now)

        get :index, params: { upcoming: true }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'does not list if scheduled now and status is finished' do
        FactoryBot.create(:dog_walking, :finished, scheduled_at: Time.zone.now)

        get :index, params: { upcoming: true }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'does not list if scheduled now and status is walking' do
        FactoryBot.create(:dog_walking, :walking, scheduled_at: Time.zone.now)

        get :index, params: { upcoming: true }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'list if scheduled in future and status is scheduled' do
        dog_walking1 = FactoryBot.create(:dog_walking, :scheduled, scheduled_at: 1.second.from_now)
        dog_walking2 = FactoryBot.create(:dog_walking, :scheduled, scheduled_at: 1.day.from_now)

        get :index, params: { upcoming: true }
        dog_walkings = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(dog_walkings.count).to eq(2)
        expect(dog_walkings).to match_array([{
          'id' => dog_walking1.id,
          'status' => dog_walking1.status,
          'duration' => dog_walking1.duration,
          'price' => dog_walking1.price,
          'scheduled_at' => dog_walking1.decorate.scheduled_at,
          'started_at' => nil,
          'finished_at' => nil,
          'pets' => dog_walking1.pets.count
        }, {
          'id' => dog_walking2.id,
          'status' => dog_walking2.status,
          'duration' => dog_walking2.duration,
          'price' => dog_walking2.price,
          'scheduled_at' => dog_walking2.decorate.scheduled_at,
          'started_at' => nil,
          'finished_at' => nil,
          'pets' => dog_walking2.pets.count
        }])
      end

      it 'list if scheduled now and status is scheduled' do
        dog_walking = FactoryBot.create(:dog_walking, :scheduled, scheduled_at: Time.zone.now)

        get :index, params: { upcoming: true }
        dog_walkings = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(dog_walkings.count).to eq(1)
        expect(dog_walkings).to match_array([{
          'id' => dog_walking.id,
          'status' => dog_walking.status,
          'duration' => dog_walking.duration,
          'price' => dog_walking.price,
          'scheduled_at' => dog_walking.decorate.scheduled_at,
          'started_at' => nil,
          'finished_at' => nil,
          'pets' => dog_walking.pets.count
        }])
      end
    end
  end
end
