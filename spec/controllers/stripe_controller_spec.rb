require 'rails_helper'

RSpec.describe StripeController, type: :controller do
  describe 'GET #callback' do
    let(:user) { create(:user_customer) }  # Assuming you have a user factory
    let(:restaurant) { create(:restaurant) }
    let(:user) {restaurant.user}

    before do
      allow(Stripe::OAuth).to receive(:token).and_return(OpenStruct.new(stripe_user_id: 'some_stripe_user_id'))
      session[:user_id_for_stripe] = user.id
    end

    context 'when user is found' do
      it 'updates the user\'s restaurant with Stripe account id and redirects to root path' do
        get :callback, params: { code: 'auth_code' }
        expect(user.restaurant.reload.stripe_account_id).to eq('some_stripe_user_id')
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Successfully connected Stripe and created restaurant')
      end
    end

    context 'when user is not found' do
      before do
        session[:user_id_for_stripe] = nil
      end
      it 'redirects to home path' do
        get :callback, params: { code: 'auth_code' }
        expect(response).to redirect_to(home_path)
      end
    end

    # Additional tests for scenarios like Stripe OAuth failures can be added here
  end
end
