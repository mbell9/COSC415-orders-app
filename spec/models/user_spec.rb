require 'rails_helper'

RSpec.describe User, type: :model do
  context 'on creation' do
    it 'is valid' do
      user = User.create!(email: "look@gmail.com", password: "abc123", role: "customer")
      expect(user).to be_valid
    end
  end

  context 'method' do
    it 'correctly identifies the role' do
      user = User.create!(email: "look@gmail.com", password: "abc123", role: "customer")
      user2 = User.create!(email: "look2@gmail.com", password: "abc1234", role: "owner")
      expect(user).to respond_to(:is_customer?)
      expect(user).to respond_to(:is_restaurant?)
      expect(user.is_customer?).to be true
      expect(user2.is_customer?).to be false
      expect(user.is_restaurant?).to be false
      expect(user2.is_restaurant?).to be true
    end
  end
end
