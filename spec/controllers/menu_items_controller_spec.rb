# spec/controllers/menu_items_controller_spec.rb

require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
  let(:restaurant_user) { FactoryBot.create(:user_owner) }
  let(:restaurant) { FactoryBot.create(:restaurant, user: restaurant_user) }
  let(:customer) { FactoryBot.create(:customer) }
  let(:menu_item) { FactoryBot.create(:menu_item, restaurant: restaurant) }
  before do
    sign_in restaurant_user # Devise test helper for signing in
  end
  render_views

  describe 'GET #new' do
    it 'initializes a new menu_item associated with the current restaurant' do
      get :new, params: { restaurant_id: restaurant.id }
      expect(assigns(:menu_item)).to be_a_new(MenuItem)
    end
  end

  describe 'GET #index' do
    it 'shows the restaurant menu_items' do
      get :index, params: { restaurant_id: restaurant.id }
      expect(assigns(:menu_items)).to eq(restaurant.menu_items)
    end
  end


  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the menu item and redirects to the restaurant's menu items" do
        new_name = "New Name"
        patch :update, params: { restaurant_id: restaurant.id, id: menu_item.id, menu_item: { name: new_name } }

        menu_item.reload # Reload the menu item from the database to get the updated attributes

        expect(menu_item.name).to eq(new_name)
        expect(response).to redirect_to(restaurant_menu_items_path(restaurant))
        expect(flash[:notice]).to eq('Menu item was successfully updated.')
      end
    end

    context "with invalid parameters" do
      it "renders the edit template" do
        invalid_name = "" # Invalid name
        patch :update, params: { restaurant_id: restaurant.id, id: menu_item.id, menu_item: { name: invalid_name } }

        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to_not be_empty
      end
    end
  end

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

    context "with invalid restaurant_id param" do
      it "redirects to the home path" do
        get :index, params: { restaurant_id: -1 }
        expect(response).to redirect_to home_path
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

  describe "DELETE #destroy" do
  let!(:menu_item) { FactoryBot.create(:menu_item, restaurant: restaurant) }

  context "as restaurant owner" do
    it "deletes the menu item" do
      expect {
        delete :destroy, params: { restaurant_id: restaurant.id, id: menu_item.id }
      }.to change(MenuItem, :count).by(-1)
    end

    it "redirects to the menu items index" do
      delete :destroy, params: { restaurant_id: restaurant.id, id: menu_item.id }
      expect(response).to redirect_to restaurant_menu_items_path(restaurant)
    end
  end

  context "as unauthorized user" do
    let(:other_user) { FactoryBot.create(:user_owner) }

    before do
      sign_in other_user
    end

    it "does not delete the menu item" do
      expect {
        delete :destroy, params: { restaurant_id: restaurant.id, id: menu_item.id }
      }.not_to change(MenuItem, :count)
    end

    it "redirects to the root path" do
      delete :destroy, params: { restaurant_id: restaurant.id, id: menu_item.id }
      expect(response).to redirect_to root_path
    end
  end

  context "with a non-existent menu item" do
    it "does not change the MenuItem count" do
      expect {
        delete :destroy, params: { restaurant_id: restaurant.id, id: -1 }
      }.not_to change(MenuItem, :count)
      expect(assigns(:menu_item)).to be_nil
    end

    it "redirects to the home page" do
      delete :destroy, params: { restaurant_id: restaurant.id, id: -1 }
      expect(response).to redirect_to(home_path)
    end
  end
end

describe "GET #customer_index" do

  before do
    sign_in customer.user
  end
  context "with a valid restaurant" do

    it "assigns @restaurant" do
      get :customer_index, params: { restaurant_id: restaurant.id }
      expect(assigns(:restaurant)).to eq(restaurant)
    end

    it "assigns @menu_items" do
      # Create some menu items associated with the restaurant
      menu_items = create_list(:menu_item, 3, restaurant: restaurant)

      get :customer_index, params: { restaurant_id: restaurant.id }
      expect(assigns(:menu_items)).to match_array(menu_items)
    end
  end

  context "with an invalid restaurant" do
    it "redirects to home_path" do

      get :customer_index, params: { restaurant_id: 'invalid_id' }
      expect(response).to redirect_to(home_path)
      
    end
  end
end

end
