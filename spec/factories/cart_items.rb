FactoryBot.define do
  factory :cart_item do
    association :cart
    association :menu_item

    quantity { Faker::Number.between(from: 1, to: 10) } # Example quantity between 1 and 10

    # Traits for specific scenarios can be added if needed

    trait :invalid_quantity do
      quantity { 0 }
    end

  end
end
