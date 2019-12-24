require 'rails_helper'

RSpec.describe TablePriceSerializer do
  it 'serialize object' do
    table_price = FactoryBot.create(:table_price)
    serializer = described_class.new(table_price)

    expect(serializer.to_h).to include(
      id: table_price.id,
      cadence: table_price.cadence,
      price: table_price.price,
      price_additional: table_price.price_additional
    )
  end
end
