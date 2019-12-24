require 'rails_helper'

RSpec.describe Dog, type: :model do
  context 'validadations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_presence_of(:dog_breed) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age).is_greater_than_or_equal_to(0) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:dog_breed) }
  end
end
