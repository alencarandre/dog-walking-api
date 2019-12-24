FactoryBot.define do
  factory :table_price do
    cadence { 30 }
    price { 25.0 }
    price_additional { 15.0 }
  end
end
