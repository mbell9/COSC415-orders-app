require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user_customer) { FactoryBot.create(:user_customer) }
  let(:user_owner) { FactoryBot.create(:user_owner) }

  # Testing associations
  it { is_expected.to have_one(:customer).dependent(:destroy) }
  it { is_expected.to have_one(:restaurant).dependent(:destroy) }

  #nested attributes
  it 'accepts nested attributes for restaurant' do
    expect(User.nested_attributes_options).to have_key(:restaurant)
  end

  it 'accepts nested attributes for customer' do
    expect(User.nested_attributes_options).to have_key(:customer)
  end


  # Testing the is_customer? and is_restaurant?
  describe 'should be either a customer or a restaurant -' do

    it 'should respond to is_customer? and is_restaurant?' do
      expect(User.new).to respond_to(:is_customer?)
      expect(User.new).to respond_to(:is_restaurant?)
    end

    context 'when a customer:' do
      it 'should return true for customer false for restaurant' do
        expect(user_customer.is_customer?).to be_truthy
        expect(user_customer.is_restaurant?).to be_falsey
      end
    end

    context 'when a restaurant:' do
      it 'should return true for restaurant false for customer' do
        expect(user_owner.is_customer?).to be_falsey
        expect(user_owner.is_restaurant?).to be_truthy
      end
    end

  end
end
