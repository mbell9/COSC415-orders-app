require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:customer) { create(:customer) }
  let(:restaurant) { create(:restaurant) }
  let(:cart) { create(:cart, customer: customer, restaurant: restaurant) }

  describe "GET #show" do
    it "assigns @cart" do
      get :show, params: { id: cart.id }
      expect(assigns(:cart)).to eq(cart)
    end

    it "renders the show template" do
      get :show, params: { id: cart.id }
      expect(response).to render_template("show")
    end
  end
end
