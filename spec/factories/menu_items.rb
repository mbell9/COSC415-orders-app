# spec/factories/menu_items.rb

FactoryBot.define do
  factory :menu_item do
    name { "Sample Dish" }
    description { "A delightful sample dish." }
    price { 10.99 }
    association :restaurant
    category { "appetizer" }  # Add this
    spiciness { "mild" }      # And this
  end
end
