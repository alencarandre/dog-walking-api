require 'rails_helper'

RSpec.describe DogBreed, type: :model do
  context 'validadations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
  end

  context 'associations' do
    it { is_expected.to have_one(:dog) }
  end
end
