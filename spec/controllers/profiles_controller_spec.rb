require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:customer) {FactoryBot.create(:customer)}
  let(:restaurant) { FactoryBot.create(:restaurant) }

  describe 'GET #show' do
    context 'when the user is a customer' do
      before do
        sign_in customer.user
        get :show
      end

      it 'assigns @customer' do
        expect(assigns(:customer)).to eq(customer)
      end

      it 'renders the customers/show template' do
        expect(response).to render_template('customers/show')
      end
    end

    context 'when the user is a restaurant' do
      before do
        sign_in restaurant.user
        get :show
      end

      it 'assigns @restaurant' do
        expect(assigns(:restaurant)).to eq(restaurant)
      end

      it 'assigns @reviews' do
        # Ensure some reviews exist for the restaurant if needed
        expect(assigns(:reviews)).to eq(restaurant.reviews.order(created_at: :desc).limit(5))
      end

      it 'renders the restaurants/profile template' do
        expect(response).to render_template('restaurants/profile')
      end
    end
  end

  describe 'GET #edit' do
    context 'when Turbo-Frame header is not present' do
      it 'redirects to the home path' do
        sign_in customer.user
        get :edit
        expect(response).to redirect_to(home_path)
      end
    end

    context 'when the user is a customer and Turbo-Frame header is present' do
      before do
        request.headers["Turbo-Frame"] = "some_value"
        sign_in customer.user
        get :edit
      end

      it 'assigns @customer' do
        expect(assigns(:customer)).to eq(customer)
      end

      it 'renders the customers/edit template' do
        expect(response).to render_template('customers/edit')
      end
    end

    context 'when the user is a restaurant and Turbo-Frame header is present' do
      before do
        request.headers["Turbo-Frame"] = "some_value"
        sign_in restaurant.user
        get :edit
      end

      it 'assigns @restaurant' do
        expect(assigns(:restaurant)).to eq(restaurant)
      end

      it 'renders the restaurants/edit template' do
        expect(response).to render_template('restaurants/edit')
      end
    end
  end
end
