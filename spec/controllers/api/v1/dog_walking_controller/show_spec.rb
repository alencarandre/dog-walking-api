require 'rails_helper'

RSpec.describe Api::V1::DogWalkingsController, type: :controller do
  describe '#show' do
    it 'returns http 404 if pass invalid dog_walking' do
      get :show, params: { id: 999 }

      expect(response).to have_http_status(404)
    end

    it 'show detailed dog walking' do
      dog_walking = FactoryBot.create(:dog_walking)

      get :show, params: { id: dog_walking.id }
      result = JSON.parse(response.body)

      expect(result).to include(
        'id' => dog_walking.id,
        'status' => dog_walking.status,
        'duration' => dog_walking.duration,
        'real_duration' => dog_walking.decorate.real_duration,
        'price' => dog_walking.price,
        'final_price' => dog_walking.final_price,
        'latitude' => dog_walking.latitude,
        'longitude' => dog_walking.longitude,
        'scheduled_at' => dog_walking.decorate.scheduled_at,
        'started_at' => dog_walking.decorate.started_at,
        'finished_at' => dog_walking.decorate.finished_at,
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
