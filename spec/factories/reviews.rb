FactoryBot.define do
  factory :review do
    association :customer
    association :restaurant

    rating { rand(1..5) } # Random rating between 1 and 5
    comment { Faker::Restaurant.review }

    # Optional: Trait for creating a review without a recorded date
    trait :without_recorded_date do
      recorded_date { nil }
    end

    # Add more traits for specific scenarios as needed
  end
end
