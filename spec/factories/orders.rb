FactoryBot.define do
  factory :order do
    customer { nil }
    restaurant { nil }
    status { "MyString" }
    total_price { "9.99" }
  end
end
