require 'faker'

FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
    description { Faker::Lorem.sentence }
    address { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.phone_number }
    operating_hours { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
  end
end
