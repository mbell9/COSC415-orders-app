# spec/factories/restaurants.rb

FactoryBot.define do
    factory :restaurant do
      name { "Sample Restaurant" }
      description { "Delicious food from around the world." }
      address { "123 Food St, Hamilton" }
      phone_number { "123-456-7890" }
      operating_hours { "9:00 AM - 9:00 PM" }
    end
  end