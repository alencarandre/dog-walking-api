require 'rails_helper'

RSpec.describe Api::V1::DogsController, type: :controller do
  describe '#index' do
    it 'list all dogs' do
      dog1 = FactoryBot.create(:dog, name: 'Buddy', age: 1)
      dog2 = FactoryBot.create(:dog, name: 'Molly', age: 5)

      get :index

      dogs = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(dogs.count).to eq(2)
      expect(dogs).to eq([{
        'id' => dog1.id,
        'name' => dog1.name,
        'age' => dog1.age,
        'dog_breed' => {
          'id' => dog1.dog_breed.id,
          'name' => dog1.dog_breed.name
        }
      }, {
        'id' => dog2.id,
        'name' => dog2.name,
        'age' => dog2.age,
        'dog_breed' => {
          'id' => dog2.dog_breed.id,
          'name' => dog2.dog_breed.name
        }
      }])
    end
  end
end
