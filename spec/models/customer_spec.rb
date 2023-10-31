require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'check validity' do
    context 'on creation' do
      it 'is valid with valid attributes' do
        customer = FactoryBot.build(:customer)
        expect(customer).to be_valid
      end
      it 'is not valid without an address' do
        customer = FactoryBot.build(:customer, email: nil)
        expect(customer).not_to be_valid
        expect(customer.errors[:email]).to include("can't be blank")
      end

      it 'is not valid with an invalid phone number' do
        customer = FactoryBot.build(:customer, phone_number: '1234')
        expect(customer).not_to be_valid
        expect(customer.errors[:phone_number]).to include("is not a valid US phone number")
      end
    end
    context 'on update' do
      it 'updates on correct attributes' do
        customer = FactoryBot.create(:customer)
        customer.name = "new name"
        expect(customer).to be_valid
      end
      it 'updates only the specified attributes' do
        customer = FactoryBot.create(:customer)
        customer.name = "new name"

        expect(customer).to be_valid
        expect(customer.changed?).to be(true)
        expect(customer.changed_attributes.keys).to eq(['name'])
      end
      it 'doesn not update on invalid attributes' do
        customer = FactoryBot.create(:customer)
        customer.phone_number = "12234"
        expect(customer).not_to be_valid
      end
    end
  end
end
