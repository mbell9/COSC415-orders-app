# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a customer
customer = Customer.create!(name: "John Doe", email: "john.doe@example.com")

# Create a restaurant
restaurant = Restaurant.create!(name: "Example Restaurant", description: "testing testing", address: "Hamilton123", phone_number: "000", operating_hours: "never")

# Create a menu item
menu_item = MenuItem.create!(name: "Burger", price: 10.0, description: "this is a burger", restaurant: restaurant)

# Create a cart
cart = Cart.create!(customer: customer, restaurant: restaurant)

# Add items to the cart
CartItem.create!(cart: cart, menu_item: menu_item, quantity: 1)