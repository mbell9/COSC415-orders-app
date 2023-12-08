require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  render_views
  let(:restaurant) { FactoryBot.create(:restaurant) }
  let(:user) { FactoryBot.create(:user_owner) }
  let(:customer) { FactoryBot.create(:customer, user: user) }
  let(:valid_attributes) { { rating: 4, comment: 'Updated review' } }
  let(:invalid_attributes) { { rating: nil, comment: '' } }
  let(:review) { FactoryBot.create(:review, customer: customer, restaurant: restaurant) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:customer).and_return(customer)
  end
  describe 'GET #index' do
    context 'when the restaurant exists' do
      it 'assigns @reviews and renders the index template' do
        review = FactoryBot.create(:review, restaurant: restaurant)
        get :index, params: { restaurant_id: restaurant.id }
        expect(assigns(:reviews)).to eq([review])
        expect(response).to render_template(:index)
      end
    end

    context 'when the restaurant does not exist' do
      it 'redirects to the home path' do
        get :index, params: { restaurant_id: -1 }
        expect(response).to redirect_to(home_path)
      end
    end
  end
  describe 'GET #new' do
    context 'when the restaurant exists' do
      context 'and the user has not reviewed it yet' do
        it 'builds a new review' do
          get :new, params: { restaurant_id: restaurant.id }
          expect(assigns(:review)).to be_a_new(Review)
          expect(response).to render_template(:new)
        end
      end

      context 'and the user has already reviewed it' do
        it 'redirects to the restaurant path with an alert' do
          FactoryBot.create(:review, restaurant: restaurant, customer: customer)
          get :new, params: { restaurant_id: restaurant.id }
          expect(response).to redirect_to(restaurant_path(restaurant))
          expect(flash[:alert]).to eq('You have already reviewed this restaurant.')
        end
      end
    end

    context 'when the restaurant does not exist' do
      it 'redirects to the home path' do
        get :new, params: { restaurant_id: -1 }
        expect(response).to redirect_to(home_path)
      end
    end
  end


  describe 'POST #create' do
    context 'when the restaurant exists' do
      context 'with valid attributes' do
        it 'creates a new Review and redirects to the restaurant path' do
          expect {
            post :create, params: { restaurant_id: restaurant.id, review: valid_attributes }
          }.to change(Review, :count).by(1)
          expect(response).to redirect_to(restaurant_path(restaurant))
        end
      end

      context 'with invalid attributes' do
        it 'does not create a new Review and re-renders the new template' do
          expect {
            post :create, params: { restaurant_id: restaurant.id, review: invalid_attributes }
          }.to_not change(Review, :count)
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when the restaurant does not exist' do
      it 'redirects to the home path' do
        post :create, params: { restaurant_id: -1, review: valid_attributes }
        expect(response).to redirect_to(home_path)
      end
    end

    context 'when the customer does not exist' do
      before { allow(user).to receive(:customer).and_return(nil) }

      it 'redirects to the home path' do
        allow(controller).to receive(:current_user).and_return(User.new) # assuming User.new has no associated customer
        post :create, params: { restaurant_id: restaurant.id, review: valid_attributes }
        expect(response).to redirect_to(home_path)
      end
    end
  end
  describe 'GET #edit' do
    context 'when the review exists and belongs to the current user' do
      it 'assigns @review and renders the edit template' do
        get :edit, params: { restaurant_id: restaurant.id, id: review.id }
        expect(assigns(:review)).to eq(review)
        expect(response).to render_template(:edit)
      end
    end

    context 'when the review does not exist or does not belong to the current user' do
      it 'redirects to the restaurants path with an alert' do
        other_user = FactoryBot.create(:user_customer)
        other_customer = FactoryBot.create(:customer, user: other_user)
        other_review = FactoryBot.create(:review, customer: other_customer, restaurant: restaurant)

        get :edit, params: { restaurant_id: restaurant.id, id: other_review.id }
        expect(response).to redirect_to(restaurants_path)
        expect(flash[:alert]).to eq('Review not found.')
      end
    end
  end


  describe 'PATCH #update' do
    context 'when the review exists and belongs to the current user' do
      context 'with valid attributes' do
        it 'updates the requested review and redirects to the restaurant path' do
          patch :update, params: { restaurant_id: restaurant.id, id: review.id, review: valid_attributes }
          review.reload
          expect(review.rating).to eq(4)
          expect(review.comment).to eq('Updated review')
          expect(response).to redirect_to(restaurant_path(restaurant))
        end
      end

    #   context 'with invalid attributes' do
    #     it 'does not update the review and re-renders the edit template' do
    #       patch :update, params: { restaurant_id: restaurant.id, id: review.id, review: invalid_attributes }
    #       expect(response).to render_template(:edit)
    #     end
    #   end
    end

    # context 'when the review does not exist or does not belong to the current user' do
    #   it 'does not update the review and redirects to the restaurants path with an alert' do
    #     other_user = FactoryBot.create(:user_customer)
    #     other_customer = FactoryBot.create(:customer, user: other_user)
    #     other_review = FactoryBot.create(:review, customer: other_customer, restaurant: restaurant)

    #     patch :update, params: { restaurant_id: restaurant.id, id: other_review.id, review: valid_attributes }
    #     expect(response).to redirect_to(restaurants_path)
    #     expect(flash[:alert]).to eq('Review not found or not authorized.')
    #   end
    # end
  end
end


  
