require 'rails_helper'

describe BrowseController, type: :controller do
  let(:user) { FactoryBot.create(:user_customer) }
  let(:customer) { FactoryBot.create(:customer, user: user) }

  let(:restaurant_user) { FactoryBot.create(:user_owner) }
  let(:restaurant) { FactoryBot.create(:restaurant, user: restaurant_user) }
  let!(:restaurants) { FactoryBot.create_list(:restaurant, 3) }

  render_views

  describe 'GET #index' do
    context 'when user is a customer' do
      before do
        sign_in customer
        get :index
      end

      it 'assigns @restaurants' do
        expect(assigns(:restaurants)).to match_array(restaurants)
      end
    end

    context 'when user is a restaurant' do
      before do
        sign_in restaurant_user
        get :index
      end

      it 'redirects to home path' do
        expect(response).to redirect_to(home_path)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is a customer' do
      before do
        sign_in customer
        get :show, params: { id: restaurant.id }
      end

      it 'assigns @restaurant' do
        expect(assigns(:restaurant)).to eq(restaurant)
      end
    end

    context 'when user is a restaurant' do
      before do
        sign_in restaurant_user
        get :show, params: { id: restaurant.id }
      end

      it 'redirects to home path' do
        expect(response).to redirect_to(home_path)
      end
    end
  end
end