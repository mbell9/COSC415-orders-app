require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'on creation' do
    it 'is valid' do
      customer = Customer.create(name: "JMC", phone_number:"646-238-3289", address:"61 Ridgeway Avenue")
      restaurant = Restaurant.create(name: "The Chicken Kitchen",description: "Delish",address: "Chicken Kitchen Plaza",phone_number: "347-573-1021",operating_hours: "Always")
      cart = Cart.new
      customer.cart = cart
      expect(customer.cart).to be_valid
      restaurant.carts << cart
      expect(restaurant.carts[0]).to be_valid
    end
  end

  context 'method' do 
    it 'responds' do 
      customer = Customer.create(name: "JMC", phone_number:"646-238-3289", address:"61 Ridgeway Avenue")
      restaurant = Restaurant.create(name: "The Chicken Kitchen",description: "Delish",address: "Chicken Kitchen Plaza",phone_number: "347-573-1021",operating_hours: "Always")
      cart = Cart.new
      customer.cart = cart
      expect(customer.cart).to respond_to(:clear_cart)
    end

    it 'works' do 
      customer = Customer.create(name: "JMC", phone_number:"646-238-3289", address:"61 Ridgeway Avenue")
      restaurant = Restaurant.create(name: "The Chicken Kitchen",description: "Delish",address: "Chicken Kitchen Plaza",phone_number: "347-573-1021",operating_hours: "Always")
      cart = Cart.new
      item = CartItem.new
      item.quantity = 2
      menu = MenuItem.new
      menu.name = "Big Chicken"
      menu.price = 10.99
      restaurant.menu_items << menu
      item.menu_item = menu
      customer.cart = cart
      customer.cart.restaurant = restaurant
      expect(customer.cart.cart_items).to be_empty
      #expect(cart.restaurant_id).not_to be_nil
      customer.cart.cart_items << item
      # Check that cart successfully adds item
      expect(customer.cart.cart_items[0].menu_item.name).to eq("Big Chicken")
      customer.cart.clear_cart
      expect(customer.cart.cart_items).to be_empty
    end
  end
end
