FactoryBot.define do
  factory :order_item do
    association :order
    association :menu_item

    quantity { Faker::Number.between(from: 1, to: 10) } # Random quantity between 1 and 10

    # Add traits or additional customizations as needed

    trait :invalid_quantity do
      quantity { 0 }
    end

  end
end
