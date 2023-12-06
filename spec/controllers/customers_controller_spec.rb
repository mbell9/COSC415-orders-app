# # spec/controllers/customers_controller_spec.rb

# require 'rails_helper'

# RSpec.describe CustomersController, type: :controller do
#   render_views
#   describe 'GET #show' do
#     it 'assigns the requested customer to @customer' do
#       customer = FactoryBot.create(:customer)
#       get :show, params: { id: customer.id }
#       expect(assigns(:customer)).to eq(customer)
#     end

#     it 'renders the show template' do
#       customer = FactoryBot.create(:customer)
#       get :show, params: { id: customer.id }
#       expect(response).to render_template(:show)
#     end
#   end

#   describe 'GET #show' do
#     it 'assigns the requested customer to @customer' do
#       customer = FactoryBot.create(:customer)
#       get :edit, params: { id: customer.id }
#       expect(assigns(:customer)).to eq(customer)
#     end

#     it 'renders the edit template' do
#       customer = FactoryBot.create(:customer)
#       get :edit, params: { id: customer.id }
#       expect(response).to render_template(:edit)
#     end
#   end

#   describe 'PUT #update' do
#     context 'with valid attributes' do
#       it 'updates the customer' do
#         # test that the customer's attributes get updated with the provided data
#         customer = FactoryBot.create(:customer)
#         put :update, params: { id: customer.id, customer: {name: "my new name"} }
#         customer.reload
#         expect(customer.name).to eq("my new name")
#       end

#       it 'reformates the phone number' do
#         # test that the customer's attributes get updated with the provided data
#         customer = FactoryBot.create(:customer)
#         put :update, params: { id: customer.id, customer: {phone_number: "111.222.3333"} }
#         customer.reload
#         expect(customer.phone_number).to eq("111-222-3333")
#       end

#       it 'redirects to the customer profile' do
#         # test that after a successful update, it redirects back to the profile
#         customer = FactoryBot.create(:customer)
#         put :update, params: { id: customer.id, customer: {name: "my new name"} }
#         expect(response).to redirect_to(profile_path)
#       end
#     end

#     context 'with invalid attributes' do
#       it 'does not update the customer' do
#         # test that the customer's attributes don't get updated with invalid data
#         customer = FactoryBot.create(:customer)
#         put :update, params: { id: customer.id, customer: {phone_number: "123"} }
#         customer.reload
#         expect(customer.phone_number).not_to eq("123")
#       end

#       it 're-renders the edit template' do
#         # test that it re-renders the edit form for the user to correct their input
#         customer = FactoryBot.create(:customer)
#         put :update, params: { id: customer.id, customer: {phone_number: "123"} }
#         expect(response).to render_template(:edit)
#       end
#     end
#   end
# end


require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let(:user) { FactoryBot.create(:user_customer) }
  let(:restaurant_user) { FactoryBot.create(:user_owner) } # Assuming this user responds true to is_restaurant?
  let(:customer) { FactoryBot.create(:customer, user: user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    context 'when user is a restaurant' do
      before { allow(controller).to receive(:current_user).and_return(restaurant_user) }

      it 'assigns the requested customer to @customer' do
        get :show, params: { id: customer.id }
        expect(assigns(:customer)).to eq(customer)
      end

      # it 'redirects to home_path if customer not found' do
      #   get :show, params: { id: 'invalid' }
      #   expect(response).to redirect_to(home_path)
      # end
    end

    # context 'when user is not a restaurant' do
    #   it 'redirects to profile_path' do
    #     get :show, params: { id: customer.id }
    #     expect(response).to redirect_to(profile_path)
    #   end
    # end
  end

  # describe 'GET #edit' do
  #   it 'assigns the customer to @customer' do
  #     get :edit
  #     expect(assigns(:customer)).to eq(user.customer)
  #   end
  # end

  # describe 'PATCH #update' do
  #   context 'with valid attributes' do
  #     it 'updates the customer and redirects' do
  #       patch :update, params: { id: customer.id, customer: { name: 'New Name' } }
  #       customer.reload
  #       expect(customer.name).to eq('New Name')
  #       expect(response).to redirect_to(profile_path)
  #     end
  #   end

  #   context 'with invalid attributes' do
  #     it 'does not update the customer and redirects' do
  #       patch :update, params: { id: customer.id, customer: { name: '' } }
  #       customer.reload
  #       expect(customer.name).not_to eq('')
  #       expect(response).to redirect_to(profile_path)
  #     end
  #   end
  # end

  # # Add more tests for filter_blank_params method and other scenarios as needed
  # describe 'PATCH #update with filter_blank_params' do
  #   let(:existing_customer) { FactoryBot.create(:customer, user: user, name: 'Existing Name', address: 'Existing Address') }

  #   before do
  #     allow(controller).to receive(:current_user).and_return(user)
  #     user.customer = existing_customer
  #   end

  #   context 'when some attributes are blank' do
  #     it 'retains existing attributes if new values are blank' do
  #       patch :update, params: { id: existing_customer.id, customer: { name: '', address: 'New Address' } }
  #       existing_customer.reload
  #       expect(existing_customer.name).to eq('Existing Name') # Unchanged
  #       expect(existing_customer.address).to eq('New Address') # Updated
  #     end

  #     it 'updates attributes if new values are provided' do
  #       patch :update, params: { id: existing_customer.id, customer: { name: 'New Name', address: '' } }
  #       existing_customer.reload
  #       expect(existing_customer.name).to eq('New Name') # Updated
  #       expect(existing_customer.address).to eq('Existing Address') # Unchanged
  #     end
  #   end
  # end

end
