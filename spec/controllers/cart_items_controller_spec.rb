require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do
  let(:customer) { create(:customer) }
  let(:restaurant) { create(:restaurant) }
  let(:menu_item) { create(:menu_item, restaurant: restaurant) }
  let(:cart) { create(:cart, customer: customer, restaurant: restaurant) }
  let(:cart_item) { create(:cart_item, cart: cart, menu_item: menu_item) }

  describe "POST #create" do
    it "creates a new cart item" do
      expect {
        post :create, params: { cart_id: cart.id, menu_item_id: menu_item.id }
      }.to change(CartItem, :count).by(1)
    end
  end

  describe "PATCH #add_to_cart" do
    it "increases the cart item quantity" do
      cart_item
      expect {
        patch :add_to_cart, params: { id: cart_item.id, cart_id: cart.id }
      }.to change { cart_item.reload.quantity }.by(1)
    end
  end

  describe "PATCH #remove_from_cart" do
    it "decreases the cart item quantity" do
      cart_item.update(quantity: 2)
      expect {
        patch :remove_from_cart, params: { id: cart_item.id, cart_id: cart.id }
      }.to change { cart_item.reload.quantity }.by(-1)
    end
  end

  describe "DELETE #destroy" do
    it "removes the cart item" do
      cart_item
      expect {
        delete :destroy, params: { id: cart_item.id, cart_id: cart.id }
      }.to change(CartItem, :count).by(-1)
    end
  end
end
