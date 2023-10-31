FactoryBot.define do
  factory :review do
    recorded_date { "2023-10-30" }
    rating { 1 }
    comment { "MyText" }
    user { nil }
    restaurant { nil }
  end
end
