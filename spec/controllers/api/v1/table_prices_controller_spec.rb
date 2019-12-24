require 'rails_helper'

RSpec.describe Api::V1::TablePricesController, type: :controller do
  describe '#index' do
    it 'list all table prices' do
      table_price1 = FactoryBot.create(:table_price, cadence: 20, price: 1, price_additional: 2)
      table_price2 = FactoryBot.create(:table_price, cadence: 30, price: 3, price_additional: 4)

      get :index

      table_prices = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(table_prices.count).to eq(2)
      expect(table_prices).to eq([{
        'id' => table_price1.id,
        'cadence' => table_price1.cadence,
        'price' => table_price1.price,
        'price_additional' => table_price1.price_additional
      }, {
        'id' => table_price2.id,
        'cadence' => table_price2.cadence,
        'price' => table_price2.price,
        'price_additional' => table_price2.price_additional
      }])
    end
  end
end
