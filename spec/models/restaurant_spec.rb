require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  context 'on creation' do 
    it 'is valid' do
      user2 = User.create!(email: "look2@gmail.com", password: "abc1234", role: "owner")
      restaurant = Restaurant.create(name: "The Chicken Kitchen",description: "Delish",address: "Chicken Kitchen Plaza",phone_number: "347-573-1021",operating_hours: "Always")
      restaurant.user = user2
      expect(restaurant).to be_valid
    end
  end

  context 'reformat phone number' do
    it 'works' do 
      restaurant = Restaurant.create(name: "The Chicken Kitchen",description: "Delish",address: "Chicken Kitchen Plaza",phone_number: "347-573-1021",operating_hours: "Always")
      expect(restaurant).to respond_to(:reformat_phone_number)
      restaurant.reformat_phone_number
      expect(restaurant.phone_number).to eq('347-573-1021')
      restaurant2 = Restaurant.create(name: "Yummy stuff",description: "Yummy",address: "Food lane",phone_number: "12453879292",operating_hours: "Always")
      restaurant2.reformat_phone_number
      expect(restaurant2.phone_number).to eq('245-387-9292')
    end
  end
end
