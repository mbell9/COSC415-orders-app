
require 'rails_helper.rb'

RSpec.describe CustomersController, type: :controller do
  let(:customer) {FactoryBot.create(:customer)}
  let(:restaurant) { FactoryBot.create(:restaurant) }

  describe 'GET show' do

    context "when user is a restaurant & customer doesn't exit" do

      before do
        sign_in restaurant.user
        get :show, params: { id: 5 }
      end

      it 'assigns @customer' do
        expect(assigns(:customer)).to be_nil
      end

      it 'renders the show template' do
        expect(response).to redirect_to(home_path)
      end
    end

    context 'when user is a restaurant' do

      before do
        sign_in restaurant.user
        get :show, params: { id: customer.id }
      end

      it 'assigns @customer' do
        expect(assigns(:customer)).to eq(customer)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not a customer' do

      before do
        sign_in customer.user
        get :show, params: { id: 1 }
      end

      it 'redirects to profile_path' do
        expect(response).to redirect_to(profile_path)
      end
    end
  end

  describe 'PUT update' do
    let(:customer_params) { { name: 'New Name', phone_number: '1234567890', address: 'New Address' } }

    before do
      sign_in customer.user
    end

    context 'with valid attributes' do
      before do
        put :update, params: { id: customer.id, customer: customer_params }
      end

      it 'updates the customer' do
        customer.reload
        expect(customer.name).to eq('New Name')
        expect(customer.phone_number).to eq('123-456-7890')
        expect(customer.address).to eq('New Address')
      end

      it 'redirects to profile_path' do
        expect(response).to redirect_to(profile_path)
      end


    end

    context 'with invalid attributes -- no error' do
      before do
        put :update, params: { id: customer.id, customer: { name: '' } }
      end

      it 'does not update the customer' do
        expect(customer.reload.name).not_to eq('')
      end

      it 'redirects to profile_path' do
        expect(response).to redirect_to(profile_path)
      end
    end

  end

end
