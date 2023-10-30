FactoryBot.define do
  factory :cart_item do
    cart { nil }
    menu_item { nil }
    quantity { 1 }
  end
end
