require 'rails_helper'

RSpec.describe ModelErrorsSerializer do
  it 'serialize object' do
    dog_walking = FactoryBot.create(:dog_walking)
    dog_walking.errors.add(:status, 'Such error here')

    serializer = described_class.new(dog_walking)

    expect(serializer.to_h).to include(
      errors: { status: 'Such error here' }
    )
  end
end
