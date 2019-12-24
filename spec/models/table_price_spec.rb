require 'rails_helper'

RSpec.describe TablePrice, type: :model do
  context 'validations' do
    it { should validate_presence_of(:cadence) }
    it { should validate_uniqueness_of(:cadence).case_insensitive }
    it { should validate_numericality_of(:cadence).is_greater_than_or_equal_to(0) }

    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

    it { should validate_presence_of(:price_additional) }
    it { should validate_numericality_of(:price_additional).is_greater_than_or_equal_to(0) }
  end

  context 'scopes' do
    describe '#lower_cadence' do
      let!(:table_price_cadence_30) { FactoryBot.create(:table_price, cadence: 30) }
      let!(:table_price_cadence_60) { FactoryBot.create(:table_price, cadence: 60) }
      let!(:table_price_cadence_90) { FactoryBot.create(:table_price, cadence: 90) }

      it 'returns lower cadence' do
        expect(described_class.lower_cadence).to eq(table_price_cadence_30)
      end
    end

    describe '#upper_cadence' do
      let!(:table_price_cadence_30) { FactoryBot.create(:table_price, cadence: 30) }
      let!(:table_price_cadence_60) { FactoryBot.create(:table_price, cadence: 60) }
      let!(:table_price_cadence_90) { FactoryBot.create(:table_price, cadence: 90) }

      it 'returns upper cadence' do
        expect(described_class.upper_cadence).to eq(table_price_cadence_90)
      end
    end
  end

  describe '#nearest_cadence' do
    let!(:table_price_cadence_30) { FactoryBot.create(:table_price, cadence: 30) }
    let!(:table_price_cadence_60) { FactoryBot.create(:table_price, cadence: 60) }
    let!(:table_price_cadence_90) { FactoryBot.create(:table_price, cadence: 90) }

    it 'returns lower cadence found' do
      table_price = described_class.nearest_cadence(25)
      expect(table_price).to eq(table_price_cadence_30)

      table_price = described_class.nearest_cadence(30)
      expect(table_price).to eq(table_price_cadence_30)

      table_price = described_class.nearest_cadence(40)
      expect(table_price).to eq(table_price_cadence_60)

      table_price = described_class.nearest_cadence(89)
      expect(table_price).to eq(table_price_cadence_90)

      table_price = described_class.nearest_cadence(1000)
      expect(table_price).to eq(table_price_cadence_90)
    end
  end
end
