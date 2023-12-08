require 'rails_helper'

RSpec.describe Cart, type: :model do
  it { should belong_to(:customer) }
  it { should belong_to(:restaurant).optional }
  it { should have_many(:cart_items).dependent(:destroy) }
  it { should have_many(:menu_items).through(:cart_items) }

  context "The clear_cart method should clear the cart and set restaurant_id to nil" do
    it 'clears all items in the cart and sets restaurant_id to nil' do
      # Building the cart and customer without saving them
      customer = create(:customer)
      restaurant = create(:restaurant)
      menu_item = create(:menu_item)
      cart = create(:cart, customer: customer, restaurant: restaurant)
      cart_item = create(:cart_item, cart: cart, menu_item: menu_item)
      cart.cart_items << cart_item
      expect(cart.cart_items.size).to eq(1)

      cart.clear_cart
      cart.reload
      expect(cart.cart_items.size).to eq(0)
      expect(cart.restaurant_id).to be_nil
    end
  end
end



