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
  

  describe 'POST #add_to_cart' do

    let(:user) { create(:user_customer) }  # Assuming you have a user factory
    let(:customer) { create(:customer) }
    let(:restaurant) { create(:restaurant) }
    let(:menu_item) { create(:menu_item, restaurant: restaurant) }
    let(:cart) { create(:cart, customer: customer, restaurant: restaurant) }
    let(:cart_item) { create(:cart_item, cart: cart, menu_item: menu_item) }

    before do
      sign_in customer.user
      controller.instance_variable_set(:@cart, cart)
    end

    context 'when the menu item does not exist' do
      it 'redirects to the home path' do
        post :add_to_cart, params: { menu_item_id: -1 }  # Non-existent ID
        expect(response).to redirect_to(home_path)
      end
    end

    context 'when adding an item from a different restaurant' do
      let(:another_restaurant) { create(:restaurant) }
      let(:another_menu_item) { create(:menu_item, restaurant: another_restaurant) }
      before do
        create(:cart_item, cart: cart, menu_item: create(:menu_item, restaurant: restaurant))
      end
    
      it 'redirects to customer_menu_path with a notice' do
        post :add_to_cart, params: { menu_item_id: another_menu_item.id, set_restaurant_id: true }
        expect(response).to redirect_to(customer_menu_path(restaurant_id: another_menu_item.restaurant_id, show_clear_cart: true))
        expect(flash[:notice]).to eq('You have cart items from another restaurant')

      end

    end

    context 'when the cart item is new' do
      let(:new_menu_item) { create(:menu_item, restaurant: restaurant) }

      it 'adds the item to the cart with a quantity of 1' do
        expect {
          post :add_to_cart, params: { menu_item_id: new_menu_item.id }
        }.to change(CartItem, :count).by(1)

        cart_item = CartItem.last
        #expect(cart_item.quantity).to eq(1)
        #expect(cart_item.menu_item_id).to eq(new_menu_item.id)
      end
    end

    context 'when the cart item already exists' do
      let!(:existing_cart_item) { create(:cart_item, cart: cart, menu_item: menu_item, quantity: 1) }

      it 'increases the quantity of the existing item' do
        expect {
          post :add_to_cart, params: { menu_item_id: menu_item.id }
        }.to change { existing_cart_item.reload.quantity }.from(1).to(2)
      end
    end

    context 'when set_restaurant_id is true and the cart\'s restaurant_id is nil' do
      let(:menu_item) { create(:menu_item, restaurant: restaurant) }

      before do
        cart.update(restaurant_id: nil)
      end

      it 'updates the cart\'s restaurant_id and redirects to customer_menu_path' do
        post :add_to_cart, params: { menu_item_id: menu_item.id, set_restaurant_id: 'true' }

        expect(cart.reload.restaurant_id).to eq(menu_item.restaurant_id)
        expect(response).to redirect_to(customer_menu_path(restaurant_id: menu_item.restaurant_id))
        expect(flash[:notice]).to eq("Cart updated to #{menu_item.restaurant.name}")
      end
    end  
    
  end

end
