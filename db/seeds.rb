# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


5.times do
  restaurant = FactoryBot.create(:restaurant)
  3.times do
    FactoryBot.create(:menu_item, restaurant: restaurant)
  end
end

Customer.create([
  {name: "John Doe", phone_number: "123-456-7890", email: "johndoe@example.com", address: "123 Main St"},
  {name: "Jane Smith", phone_number: "987-654-3210", email: "janesmith@example.com", address: "456 Elm St"},
])

# Create a customer
customer = Customer.create!(name: "Habibi Norain", phone_number: "888-888-8888", email: "habibinorain@example.com", address: "13 Oak Dr")

# Create a restaurant
restaurant = Restaurant.create!(name: "Example Restaurant", description: "testing testing", address: "Hamilton123", phone_number: "000", operating_hours: "never")

# Create a menu item
menu_item = MenuItem.create!(name: "Burger", price: 10.0, description: "this is a burger", restaurant: restaurant, category: 2, calories: 200, spiciness: 0, stock: 11, discount: 1)
menu_item2 = MenuItem.create!(name: "Pasta", price: 5.0, description: "this is pasta", restaurant: restaurant, category: 1, calories: 100, spiciness: 1, stock: 10, discount: 5)

# Create a cart
cart = Cart.create!(customer: customer, restaurant: restaurant)

# Add items to the cart
CartItem.create!(cart: cart, menu_item: menu_item, quantity: 1)

#Create an order
order  = Order.create!(customer: customer, restaurant: restaurant, total_price: 30)



