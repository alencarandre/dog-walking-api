require 'rails_helper'

RSpec.describe DogWalkingDog, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:dog_walking) }
    it { is_expected.to belong_to(:dog) }
  end
end
