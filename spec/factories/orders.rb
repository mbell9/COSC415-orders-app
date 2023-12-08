FactoryBot.define do
  factory :order do
    association :customer
    association :restaurant

    status { ["pending", "completed", "cancelled"].sample } # Example statuses
    total_price { Faker::Commerce.price(range: 10..100.0) } # Random total price within a range
    start_time { 1.hour.ago }
    end_time { Time.current }

    # Add traits for specific scenarios as needed
  end
end
