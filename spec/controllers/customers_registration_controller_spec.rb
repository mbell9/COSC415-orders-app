require 'rails_helper'

RSpec.describe Customers::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user] # or :customer, depending on your setup
  end

  describe 'GET #new' do
    it 'initializes a new customer associated with the user' do
      get :new
      expect(assigns(:user).customer).to be_a_new(Customer)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user and associated customer' do
        expect do
          post :create, params: { user: { email: 'test@example.com', password: 'password123', password_confirmation: 'password123', customer_attributes: { name: 'Test Customer', phone_number: '1234567890', address: '123 Test Street' } } }
        end.to change(User, :count).by(1).and change(Customer, :count).by(1)
      end

      it 'creates a cart for the customer' do
        post :create, params: { user: { email: 'test@example.com', password: 'password123', password_confirmation: 'password123', customer_attributes: { name: 'Test Customer', phone_number: '1234567890', address: '123 Test Street' } } }
        user = User.find_by(email: 'test@example.com')
        expect(user.customer.cart).to be_present
      end
    end

    context 'with invalid attributes' do
      it 'does not create a user or customer' do
        expect do
          post :create, params: { user: { email: '', password: 'password123', password_confirmation: 'password123', customer_attributes: { name: '', phone_number: '1234567890', address: '123 Test Street' } } }
        end.to_not change(User, :count)
      end
    end
  end

  # Add more tests if you have other custom behaviors or actions
end
