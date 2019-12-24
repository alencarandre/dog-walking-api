FactoryBot.define do
  factory :dog_walking do
    scheduled_at { 1.day.ago }
    price { 1.5 }
    duration { 30 }
    latitude { 1.5 }
    longitude { 1.5 }

    finished

    trait :scheduled do
      status { :scheduled }
      started_at { nil }
      finished_at { nil }
    end

    trait :walking do
      status { :walking }
      started_at { 2.day.ago }
      finished_at { nil }
    end

    trait :finished do
      status { :finished }
      started_at { 2.day.ago }
      final_price { 1 }
      finished_at { 1.day.from_now }
    end

    after(:build) do |dog_walking|
      if dog_walking.pets.blank?
        dog_walking.pets << FactoryBot.build(:dog)
      end
    end
  end
end
