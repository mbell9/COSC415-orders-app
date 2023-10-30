# spec/factories/customers.rb

FactoryBot.define do
  factory :customer do
    name { "Sample Customer" }
    email { "iamasamplecustomer@gmail.com" }
    phone_number { "315-273-9257" }
    address {"110 Broad street, Hamilton, NY"}
  end
end
