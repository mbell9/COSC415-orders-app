require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do

  let(:cart_item) {FactoryBot.create(:cart_item)}
  let(:cart) { cart_item.cart }
  let(:customer) { cart.customer}

  before do
    sign_in customer.user
    allow(controller).to receive(:current_user).and_return(customer.user)

  end

  describe 'POST #create' do
    context 'when Stripe Checkout Session is successfully created' do
      before do
        allow(Stripe::Checkout::Session).to receive(:create).and_return(double('session', url: 'http://example.com'))
        post :create
      end

      it 'redirects to Stripe session URL' do
        expect(response).to redirect_to('http://example.com')
      end
    end

    context 'when Stripe Checkout Session creation fails' do
      before do
        allow(Stripe::Checkout::Session).to receive(:create).and_raise(Stripe::StripeError.new('Error message'))
        post :create
      end

      it 'sets an error flash message' do
        expect(flash[:error]).to eq('Error message')
      end

      it 'redirects to cart path' do
        expect(response).to redirect_to(cart_path)
      end
    end
  end

  describe 'GET #success' do
    before do
      get :success
    end

    it 'creates an order' do
      expect(Order.count).to eq(1)
    end

    it 'sends an email to the user' do
      expect(ActionMailer::Base.deliveries.last.to).to include(customer.user.email)
    end

    it 'clears the cart' do
      expect(cart.cart_items.count).to eq(0)
    end

    it 'redirects to home path with a notice' do
      expect(response).to redirect_to(home_path)
      expect(flash[:notice]).to eq('Order was successful!')
    end
  end

  describe 'GET #cancel' do
    # Add tests for cancel action if needed
  end
end
