require 'rails_helper'

RSpec.describe Api::V1::DogWalkingsController, type: :controller do
  describe '#start_walking' do
    context 'when does not start walking' do
      it 'returns http 404 if pass invalid dog_walking' do
        patch :start_walking, params: { id: 999 }

        expect(response).to have_http_status(404)
      end

      it 'returns http 409 if is invalid status transition' do
        %i(walking finished).each do |status|
          dog_walking = FactoryBot.create(:dog_walking, status: status)

          patch :start_walking, params: { id: dog_walking.id }

          expect(response).to have_http_status(409)
        end
      end

      it 'render dog walking with errors' do
        dog_walking = FactoryBot.create(:dog_walking, :walking)

        patch :start_walking, params: { id: dog_walking.id }
        result = JSON.parse(response.body)

        expect(result).to include(
          'errors' => { 'status' => "Event 'start_walking' cannot transition from 'walking'." }
        )
      end
    end

    context 'when start walking' do
      it 'returns http 200 if pass valid dog_walking' do
        dog_walking = FactoryBot.create(:dog_walking, :scheduled)

        patch :start_walking, params: { id: dog_walking.id }

        expect(response).to have_http_status(200)
      end

      it 'render dog walking' do
        dog_walking = FactoryBot.create(:dog_walking, :scheduled)

        patch :start_walking, params: { id: dog_walking.id }
        result = JSON.parse(response.body)

        expect(result).to include(
          'id' => dog_walking.id,
          'status' => 'walking',
          'duration' => dog_walking.duration,
          'real_duration' => dog_walking.decorate.real_duration,
          'price' => dog_walking.price,
          'final_price' => dog_walking.final_price,
          'latitude' => dog_walking.latitude,
          'longitude' => dog_walking.longitude,
          'scheduled_at' => dog_walking.decorate.scheduled_at,
          'started_at' => Time.zone.now.strftime('%Y-%m-%d %H:%M:%S'),
          'finished_at' => nil,
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
