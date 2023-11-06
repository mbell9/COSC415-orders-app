# spec/controllers/menu_items_controller_spec.rb

require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
  render_views
  let!(:restaurant) { create(:restaurant) }

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new menu item" do
        expect {
          post :create, params: { restaurant_id: restaurant.id, menu_item: attributes_for(:menu_item) }
        }.to change(MenuItem, :count).by(1)
      end

      it "redirects to the restaurant" do
        post :create, params: { restaurant_id: restaurant.id, menu_item: attributes_for(:menu_item) }
        expect(response).to redirect_to restaurant
      end
    end

    context "with invalid attributes" do
      it "does not save the new menu item" do
        expect {
          post :create, params: { restaurant_id: restaurant.id, menu_item: attributes_for(:menu_item, name: nil) }
        }.not_to change(MenuItem, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: { restaurant_id: restaurant.id, menu_item: attributes_for(:menu_item, name: nil) }
        expect(response).to render_template :new
      end
    end
  end

  # ... any other controller action tests ...
end
