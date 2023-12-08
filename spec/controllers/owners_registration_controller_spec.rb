require 'rails_helper'

RSpec.describe Owners::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    it 'initializes a new restaurant associated with the user' do
      get :new
      expect(assigns(:user).restaurant).to be_a_new(Restaurant)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user and associated restaurant' do
        expect do
          # Example post request in RSpec test
          post :create, params: {
            user: {
            email: 'owner@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            role: 'owner',
            restaurant_attributes: {
              name: "new restaurant",
              phone_number: "555-123-4567",
              address: "some address",
              description: "new description",
              operating_hours: "Mon-Fri: 9:00 AM - 10:00 PM"
            }
          }
        }
        end.to change(User, :count).by(1).and change(Restaurant, :count).by(1)

        expect(response).to redirect_to(assigns(:stripe_url))
        expect(session[:user_id_for_stripe]).to eq(User.last.id)
      end


    end

    context 'with invalid attributes' do
      it 'does not create a user or restaurant' do
        expect do
          post :create, params: { owner: { email: '', password: 'password123', password_confirmation: 'password123', restaurant_attributes: { name: '' } } }
        end.to_not change(User, :count)
      end
    end
  end



end
