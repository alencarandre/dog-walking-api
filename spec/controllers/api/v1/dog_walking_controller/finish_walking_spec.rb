require 'rails_helper'

RSpec.describe Api::V1::DogWalkingController, type: :controller do
  describe '#finish_walking' do
    context 'when does not finish walking' do
      it 'returns http 404 if pass invalid dog_walking' do
        patch :finish_walking, params: { id: 999 }

        expect(response).to have_http_status(404)
      end

      it 'returns http 409 if is invalid status transition' do
        %i(scheduled finished).each do |status|
          dog_walking = FactoryBot.create(:dog_walking, status: status)

          patch :finish_walking, params: { id: dog_walking.id }

          expect(response).to have_http_status(409)
        end
      end

      it 'render dog walking with errors' do
        dog_walking = FactoryBot.create(:dog_walking, :finished)

        patch :finish_walking, params: { id: dog_walking.id }
        result = JSON.parse(response.body)

        expect(result).to eq(
          'errors' => { 'status' => "Event 'finish_walking' cannot transition from 'finished'." }
        )
      end
    end

    context 'when finish walking' do
      before { FactoryBot.create(:table_price, cadence: 60, price: 1, price_additional: 2) }

      it 'returns http 200 if pass valid dog_walking' do
        dog_walking = FactoryBot.create(:dog_walking, :walking)

        patch :finish_walking, params: { id: dog_walking.id }

        expect(response).to have_http_status(200)
      end

      it 'render dog walking' do
        Timecop.freeze(Time.zone.local(2500, 12, 30, 15, 45, 07)) do
          dog_walking = FactoryBot.create(:dog_walking, :walking)

          patch :finish_walking, params: { id: dog_walking.id }
          result = JSON.parse(response.body)
          dog_walking.reload

          expect(result).to include(
            'id' => dog_walking.id,
            'status' => 'finished',
            'duration' => dog_walking.duration,
            'real_duration' => dog_walking.decorate.real_duration,
            'price' => dog_walking.price,
            'final_price' => dog_walking.final_price,
            'latitude' => dog_walking.latitude,
            'longitude' => dog_walking.longitude,
            'scheduled_at' => dog_walking.decorate.scheduled_at,
            'started_at' => dog_walking.decorate.started_at,
            'finished_at' => Time.zone.now.strftime('%Y-%m-%d %H:%M:%S'),
            'pets' => [
              {
                'id' => dog_walking.pets.first.id,
                'name' => dog_walking.pets.first.name,
                'age' => dog_walking.pets.first.age,
                'dog_breed' => {
                  'id' => dog_walking.pets.first.dog_breed.id,
                  'name' => dog_walking.pets.first.dog_breed.name
                }
              }
            ]
          )
        end
      end
    end
  end
end
