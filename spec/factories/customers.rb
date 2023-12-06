
# spec/factories/customers.rb

# FactoryBot.define do
#   factory :customer do
#     name { "Sample Customer" }
#     email { "iamasamplecustomer@gmail.com" }
#     phone_number { "315-273-9257" }
#     address {"110 Broad street, Hamilton, NY"}
#   end
# end

# spec/factories/customers.rb

FactoryBot.define do
  factory :customer do
    association :user, factory: :user_customer

    name { Faker::Name.name }
    phone_number { "5551234567" }
    address { Faker::Address.full_address }

    trait :with_invalid_phone_number do
      phone_number { "12-2123-313-1" }
    end

  end
end
