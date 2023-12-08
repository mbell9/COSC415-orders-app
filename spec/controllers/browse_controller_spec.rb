require 'rails_helper'
#hello
describe BrowseController, type: :controller do
  let(:user) { FactoryBot.create(:user_customer) }
  let(:customer) { FactoryBot.create(:customer, user: user) }

  let(:restaurant_user) { FactoryBot.create(:user_owner) }
  let(:restaurant) { FactoryBot.create(:restaurant, user: restaurant_user, address: 'D Street12345') }
  let!(:first_restaurant) { FactoryBot.create(:restaurant, address: 'A Street12345') }
  let!(:second_restaurant) { FactoryBot.create(:restaurant, address: 'B Street12345') }
  let!(:third_restaurant) { FactoryBot.create(:restaurant, address: 'C Street12345') }
  let!(:restaurants) {[first_restaurant, second_restaurant, third_restaurant, restaurant] }





  render_views

  describe 'GET #index' do
    context 'when user is a customer' do
      before do
        sign_in customer.user
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

    context 'sorting by location in ascending order' do
      before do
        sign_in customer.user
        
      end
      it 'sorts restaurants by address in ascending order' do
        get :index, params: { sort: 'location', order: 'asc' }
        sorted_addresses = ['A Street12345', 'B Street12345', 'C Street12345', 'D Street12345']
        expect(assigns(:restaurants).map(&:address)).to eq(sorted_addresses)
      end
    end

    context 'sorting by location in descending order' do
      before do
        sign_in customer.user
      end
      it 'sorts restaurants by address in descending order' do
        get :index, params: { sort: 'location', order: 'desc' }
        sorted_addresses = ['D Street12345', 'C Street12345', 'B Street12345', 'A Street12345']
        expect(assigns(:restaurants).map(&:address)).to eq(sorted_addresses)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is a customer' do
      before do
        sign_in customer.user
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