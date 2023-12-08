#spec/factories/menu_items.rb
FactoryBot.define do
  factory :menu_item do
    association :restaurant

    name { Faker::Food.dish }
    price { Faker::Commerce.price(range: 2.0..50.0) }
    description { Faker::Food.description }
    category { MenuItem.categories.keys.sample }
    featured { Faker::Boolean.boolean }
    availability { Faker::Boolean.boolean }
    calories { Faker::Number.between(from: 50, to: 1000) }
    spiciness { MenuItem.spicinesses.keys.sample }
    stock { Faker::Number.between(from: 0, to: 100) }
    discount { Faker::Number.between(from: 0, to: 30) }

    # Traits for specific scenarios
    trait :featured_item do
      featured { true }
    end

    trait :unavailable_item do
      availability { false }
    end

    trait :with_high_discount do
      discount { Faker::Number.between(from: 70, to: 100) }
    end

    # Add more traits for different categories, spiciness levels, etc., as needed
  end
end
