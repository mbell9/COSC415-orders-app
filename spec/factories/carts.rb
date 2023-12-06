FactoryBot.define do
  factory :cart do
    association :customer
    association :restaurant, optional: true

    # Traits for specific scenarios, such as a cart without a restaurant
    trait :without_restaurant do
      restaurant_id { nil }
    end

    # Add more traits as needed for other specific scenarios
  end
end
