require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do
  describe 'POST #remove_from_cart' do
    let(:customer) {FactoryBot.create(:customer)}
    let(:cart) { FactoryBot.create(:cart, customer: customer) }
    let(:menu_item) { FactoryBot.create(:menu_item) }


    before do
      sign_in customer.user # Assuming you have some authentication
      controller.instance_variable_set(:@cart, cart)
    end

    context 'when menu item does not exist' do
      it 'redirects to home path' do
        post :remove_from_cart, params: { menu_item_id: 'nonexistent' }
        expect(response).to redirect_to(home_path)
      end
    end

    context 'when menu item is not in cart' do
      it 'redirects to home path with alert' do
        post :remove_from_cart, params: { menu_item_id: menu_item.id }
        expect(response).to redirect_to(home_path)
        expect(flash[:alert]).to eq 'Item not found in cart.'
      end
    end

    context 'when menu item is in cart with quantity > 1' do
      it 'reduces the quantity and redirects to cart path' do
        cart_item = create(:cart_item, cart: cart, menu_item: menu_item, quantity: 2)
        post :remove_from_cart, params: { menu_item_id: menu_item.id }
        expect(response).to redirect_to(cart_path)
        expect(flash[:notice]).to eq 'Item quantity reduced.'
        cart_item.reload
        expect(cart_item.quantity).to eq(1)
      end
    end

    context 'when menu item is in cart with quantity of 1' do
      it 'removes the item and redirects to cart path' do
        create(:cart_item, cart: cart, menu_item: menu_item, quantity: 1)
        post :remove_from_cart, params: { menu_item_id: menu_item.id }
        expect(response).to redirect_to(cart_path)
        expect(flash[:notice]).to eq 'Item removed from cart.'
        expect(cart.cart_items.find_by(menu_item: menu_item)).to be_nil
      end
    end


  end
end
