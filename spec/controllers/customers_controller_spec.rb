# spec/controllers/customers_controller_spec.rb

require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  render_views
  describe 'GET #show' do
    it 'assigns the requested customer to @customer' do
      customer = FactoryBot.create(:customer)
      get :show, params: { id: customer.id }
      expect(assigns(:customer)).to eq(customer)
    end

    it 'renders the show template' do
      customer = FactoryBot.create(:customer)
      get :show, params: { id: customer.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested customer to @customer' do
      customer = FactoryBot.create(:customer)
      get :edit, params: { id: customer.id }
      expect(assigns(:customer)).to eq(customer)
    end

    it 'renders the edit template' do
      customer = FactoryBot.create(:customer)
      get :edit, params: { id: customer.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates the customer' do
        # test that the customer's attributes get updated with the provided data
        customer = FactoryBot.create(:customer)
        put :update, params: { id: customer.id, customer: {name: "my new name"} }
        customer.reload
        expect(customer.name).to eq("my new name")
      end

      it 'reformates the phone number' do
        # test that the customer's attributes get updated with the provided data
        customer = FactoryBot.create(:customer)
        put :update, params: { id: customer.id, customer: {phone_number: "111.222.3333"} }
        customer.reload
        expect(customer.phone_number).to eq("111-222-3333")
      end

      it 'redirects to the customer profile' do
        # test that after a successful update, it redirects back to the profile
        customer = FactoryBot.create(:customer)
        put :update, params: { id: customer.id, customer: {name: "my new name"} }
        expect(response).to redirect_to(customer_path(customer))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the customer' do
        # test that the customer's attributes don't get updated with invalid data
        customer = FactoryBot.create(:customer)
        put :update, params: { id: customer.id, customer: {phone_number: "123"} }
        customer.reload
        expect(customer.phone_number).not_to eq("123")
      end

      it 're-renders the edit template' do
        # test that it re-renders the edit form for the user to correct their input
        customer = FactoryBot.create(:customer)
        put :update, params: { id: customer.id, customer: {phone_number: "123"} }
        expect(response).to render_template(:edit)
      end
    end
  end
end

# add test for create right
# add test for create with missing attribute
# add test for create with wrong attribute
# add test for update right
# add test for update with missing attribute
# add test for update with wrong attribute
# for update show only relevant attributes are affected
# show how phone number is reformatted
