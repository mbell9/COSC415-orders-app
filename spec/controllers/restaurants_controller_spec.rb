require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  let(:restaurant) { create(:restaurant) }
  let(:valid_attributes) { { name: 'New Name', phone_number: '1234567890', address: '123 Main St', description: 'New Description', operating_hours: '9-5' } }
  let(:invalid_attributes) { { name: '', phone_number: '', address: '', description: '', operating_hours: '' } }

  before do
    sign_in restaurant.user
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested restaurant' do
        patch :update, params: { id: restaurant.to_param, restaurant: valid_attributes }
        restaurant.reload
        expect(restaurant.name).to eq('New Name')
        expect(restaurant.phone_number).to eq('123-456-7890')
        expect(response).to redirect_to(profile_path)
      end
    end

    context 'with invalid params' do
      it 'does not update the restaurant' do
        patch :update, params: { id: restaurant.to_param, restaurant: invalid_attributes }
        expect(response).to redirect_to(profile_path)
      end
    end

    context 'with blank params' do
      it 'uses existing attributes for blank params' do
        patch :update, params: { id: restaurant.to_param, restaurant: { name: '', phone_number: '+11234567890' } }
        restaurant.reload
        expect(restaurant.name).to eq(restaurant.name)
        expect(restaurant.phone_number).to eq('123-456-7890')
      end
    end
  end
end
