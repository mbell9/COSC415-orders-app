require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:customer) {FactoryBot.create(:customer)}
  let(:restaurant) { FactoryBot.create(:restaurant) }

  describe "GET #main" do

    context "when user is not signed in" do
      it "renders the main page" do
        get :main
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is signed in" do


      context "as a customer" do

        before do
          sign_in customer.user
        end

        it "redirects to the restaurants path" do
          get :main
          expect(response).to redirect_to(restaurants_path)
        end
      end

      context "as a restaurant" do

        before do
          sign_in restaurant.user
        end

        it "redirects to the profile path" do
          get :main
          expect(response).to redirect_to(profile_path)
        end
      end
    end
  end
end
