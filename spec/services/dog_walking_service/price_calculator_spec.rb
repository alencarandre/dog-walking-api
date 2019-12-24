require 'rails_helper'

RSpec.describe DogWalkingService::PriceCalculator do
  let!(:table_price_cadence_lower) { FactoryBot.create(:table_price, cadence: 10, price: 11.9, price_additional: 5) }
  let!(:table_price_cadence_middle) { FactoryBot.create(:table_price, cadence: 20, price: 14.5, price_additional: 10) }
  let!(:table_price_cadence_upper) { FactoryBot.create(:table_price, cadence: 90, price: 55.7, price_additional: 15) }

  context 'when there is only one pet' do
    it 'returns lower cadence price if duration less than lower cadence' do
      price = described_class.(duration: 5, pets: 1)

      expect(price).to eq(table_price_cadence_lower.price)
    end

    it 'returns lower cadence price if duration equal lower cadence minutes' do
      price = described_class.(duration: 10, pets: 1)

      expect(price).to eq(table_price_cadence_lower.price)
    end

    context 'when duration more then lower cadence and less then upper cadence' do
      it 'calculate using middle cadence price' do
        (11..19).each do |duration|
          price = described_class.(duration: duration, pets: 1)

          expected_price = calculate_price(table_price_cadence_middle, duration, 0)
          expect(price).to eq(expected_price)
        end
      end
    end

    it 'calculate price using upper cadence price if duration more than middle cadence' do
      [21, 60, 90, 150].each do |duration|
        price = described_class.(duration: duration, pets: 1)

        expected_price = calculate_price(table_price_cadence_upper, duration, 0)
        expect(price).to eq(expected_price)
      end
    end
  end

  context 'when there is more one pet' do
    it 'returns lower cadence price if duration less than lower cadence' do
      price = described_class.(duration: 5, pets: 3)

      expect(price).to eq(table_price_cadence_lower.price + table_price_cadence_lower.price_additional * 2)
    end

    it 'returns lower cadence price if duration equal lower cadence minutes' do
      price = described_class.(duration: 10, pets: 3)

      expect(price).to eq(table_price_cadence_lower.price + table_price_cadence_lower.price_additional * 2)
    end

    context 'when duration more then lower cadence and less then upper cadence' do
      it 'calculate using middle cadence price ' do
        (11..19).each do |duration|
          price = described_class.(duration: duration, pets: 3)

          expected_price = calculate_price(table_price_cadence_middle, duration, 2)
          expect(price).to eq(expected_price)
        end
      end
    end

    it 'calculate price using upper cadence price if duration more than middle cadence' do
      [21, 60, 90,  150].each do |duration|
        price = described_class.(duration: duration, pets: 3)

        expected_price = calculate_price(table_price_cadence_upper, duration, 2)
        expect(price).to eq(expected_price)
      end
    end
  end

  private

  def calculate_price(table_price, duration, additional_pets)
    duration_in_hours = (duration / table_price.cadence.to_f)
    price = (table_price.price + table_price.price_additional * additional_pets)

    (price * duration_in_hours).round(2)
  end
end
