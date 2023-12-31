require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  render_views
  let(:user) { create(:user_customer) }  # Assuming you have a user factory
  let(:customer) { create(:customer, user: user) }
  let(:restaurant) { create(:restaurant) }
  let(:menu_item) { create(:menu_item, restaurant: restaurant,) }
  let(:cart) { create(:cart, customer: customer, restaurant: restaurant) }
  let(:cart_item) {create(:cart_item, cart: cart, menu_item: menu_item)}


  before do
    sign_in user  # Sign in with Devise, if authentication is required
  end

  # ...other tests...

  describe 'GET #back' do
    context 'when cart is found' do
      context 'and cart has a restaurant_id' do
        before do
          create(:cart_item, cart: cart, menu_item: menu_item)
          cart.update(restaurant_id: restaurant.id)
          get :back, params: { cart_id: cart.id }
        end

        it 'redirects to the customer_menu_path' do
          expect(response).to redirect_to(customer_menu_path(restaurant_id: restaurant.id))
        end
      end

      context 'and cart does not have a restaurant_id' do
        before do
          create(:cart_item, cart: cart, menu_item: menu_item)
          cart.update(restaurant_id: nil)
          get :back, params: { cart_id: cart.id }
        end

        it 'redirects to the home_path' do
          expect(response).to redirect_to(home_path)
        end
      end
    end

    context 'when cart is not found' do
      it 'redirects to the home_path' do
        get :back, params: { cart_id: -1 }  # -1 or any ID that is not in the database
        expect(response).to redirect_to home_path
      end
    end

  end

  describe 'GET #show' do
    context 'when the cart is present' do
      before do
        create(:cart, customer: customer, restaurant: restaurant)
        create(:cart_item, cart: cart, menu_item: menu_item)

        get :show
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'POST #clear_cart' do
    context 'when the cart exists' do
      before do
        create(:cart_item, cart: cart, menu_item: menu_item)
      end

      context 'with restaurant_id param' do
        it 'clears the cart, sets restaurant_id to nil, and redirects to customer_menu_path' do
          post :clear_cart, params: { restaurant_id: restaurant.id }
          cart.reload
          expect(cart.cart_items).to be_empty
          expect(cart.restaurant_id).to be_nil
          expect(response).to redirect_to(customer_menu_path(restaurant_id: restaurant.id))
          expect(flash[:notice]).to eq('Successfully cleared cart')
        end
      end

      context 'without restaurant_id param' do
        it 'clears the cart, sets restaurant_id to nil, and redirects to cart_path' do
          post :clear_cart
          cart.reload
          expect(cart.cart_items).to be_empty
          expect(cart.restaurant_id).to be_nil
          expect(response).to redirect_to(cart_path)
          expect(flash[:notice]).to eq('Successfully cleared cart')
        end
      end
    end

  end


end
