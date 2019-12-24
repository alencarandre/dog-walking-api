require 'rails_helper'

RSpec.describe Api::V1::DogWalkingController, type: :controller do
  describe '#create' do
    before do
      Timecop.freeze(Time.zone.local(2500, 12, 30, 0, 0, 0, 0))

      FactoryBot.create(:table_price, price: 1, price_additional: 2)
    end

    after { Timecop.return }

    context 'when does not create object' do
      it 'returns http status 409' do
        post :create, params: { dog_walking: { latitude: nil } }

        expect(response).to have_http_status(409)
      end

      it 'render dog walking with errors' do
        params = {
          latitude: 123.5555,
          longitude: 456.7777,
          duration: 30,
          scheduled_at: 1.day.from_now,
          started_at: nil,
          finished_at: nil,
          pet_ids: []
        }

        post :create, params: { dog_walking: params }
        result = JSON.parse(response.body)

        expect(result).to include(
          'errors' => { 'pets' => "can't be blank" }
        )
      end
    end

    context 'when create object' do
      let(:dog) { FactoryBot.create(:dog) }
      let(:params) do
        {
          latitude: 123.5555,
          longitude: 456.7777,
          duration: 30,
          scheduled_at: 1.day.from_now,
          started_at: nil,
          finished_at: nil,
          pet_ids: [ dog.id ]
        }
      end

      it 'returns http status 201' do
        post :create, params: { dog_walking: params }

        expect(response).to have_http_status(201)
      end

      it 'render object created' do
        post :create, params: { dog_walking: params }

        result = JSON.parse(response.body)

        expect(result).to include(
          'id' => DogWalking.last.id,
          'status' => 'scheduled',
          'duration' => 30,
          'real_duration' => nil,
          'price' => 1.0,
          'final_price' => nil,
          'latitude' => 123.5555,
          'longitude' => 456.7777,
          'scheduled_at' => 1.day.from_now.strftime('%Y-%m-%d %H:%M:%S'),
          'started_at' => nil,
          'finished_at' => nil,
          'pets' => [
            {
              'id' => dog.id,
              'name' => dog.name,
              'age' => dog.age,
              'dog_breed' => {
                'id' => dog.dog_breed.id,
                'name' => dog.dog_breed.name
              }
            }
          ]
        )
      end
    end
  end
end
