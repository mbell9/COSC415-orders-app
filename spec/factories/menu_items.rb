require 'faker'

FactoryBot.define do
  factory :menu_item do
    name { Faker::Food.dish }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price }
    restaurant
  end
end
