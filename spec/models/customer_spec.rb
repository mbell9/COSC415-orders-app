require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:customer) { FactoryBot.create(:customer) }

  # Testing associations
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:cart).dependent(:destroy) }
  it { is_expected.to have_many(:reviews).dependent(:destroy) }
  it { is_expected.to have_many(:orders).dependent(:destroy) }
  it { is_expected.to have_many(:restaurants).through(:orders) }

  # Testing validations
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name).on(:create) }
    it { is_expected.to validate_presence_of(:phone_number).on(:create) }
    it { is_expected.to validate_presence_of(:address).on(:create) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:address).is_at_least(10).is_at_most(100) }

    context 'when phone number is present' do
      it { is_expected.to allow_value('123-456-7890').for(:phone_number) }
      it { is_expected.not_to allow_value('invalid_phone').for(:phone_number).with_message('is not a valid US phone number') }
    end
  end

  # Testing the reformat_phone_number method
  describe '#reformat_phone_number' do
    context 'with a standard phone number' do
      it 'reformats the phone number to the standard format' do
        expect(customer.phone_number).to eq('555-123-4567')
      end
    end

    context 'when phone number has country code' do
      let(:customer_with_country_code) { FactoryBot.create(:customer, phone_number: '+11234567890') }
      it 'removes the country code and reformats the phone number' do
        expect(customer_with_country_code.phone_number).to eq('123-456-7890')
      end
    end

    context 'when phone is in the correct formant' do
      it 'does not reformat if already in correct format' do
        customer.update(phone_number: '123-456-7890')
        expect(customer.phone_number).to eq('123-456-7890')
      end
    end

  end
end
