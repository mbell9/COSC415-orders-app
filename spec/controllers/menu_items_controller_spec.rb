# spec/controllers/menu_items_controller_spec.rb

require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
  let(:valid_attributes) { { name: "Pizza", price: 10.0 } }
  let(:invalid_attributes) { { name: "", price: -5 } }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new MenuItem" do
        expect {
          post :create, params: { menu_item: valid_attributes }
        }.to change(MenuItem, :count).by(1)
      end

      it "redirects to the created menu item" do
        post :create, params: { menu_item: valid_attributes }
        expect(response).to redirect_to(MenuItem.last)
      end
    end

    context "with invalid params" do
      it "does not create a new MenuItem" do
        expect {
          post :create, params: { menu_item: invalid_attributes }
        }.not_to change(MenuItem, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: { menu_item: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  # ... Similar tests for #update and #destroy ...
end
