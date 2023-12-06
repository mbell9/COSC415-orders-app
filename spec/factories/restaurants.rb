FactoryBot.define do
  factory :restaurant do
    association :user, factory: :user_owner

    name { Faker::Restaurant.name[0..49] } # Ensure it's within the maximum length
    phone_number { "555-123-4567" } # A simple, valid US phone number format
    address { Faker::Address.full_address[0..99] } # Ensure it's within the valid length range
    description { Faker::Restaurant.description[0..499] } # Sample description
    operating_hours { "Mon-Fri: 9:00 AM - 10:00 PM" } # Example operating hours

    # Traits for invalid data can be added for testing validations
    trait :with_invalid_phone_number do
      phone_number { "12-2123-313-1" }
    end

    # You can add more traits for specific scenarios as needed
  end
end
