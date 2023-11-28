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
user = User.create!(email: "ryanparkabcde@gmail.com", password: "1234567", role: "customer")
user2 = User.create!(email: "rahulnair1@gmail.com", password: "1234567", role: "owner")
customer = Customer.create!(name: "Ragu Bhaiya", phone_number: "888-888-8888", address: "13 Oak Dr", user_id: user.id)

# Create a restaurant
restaurant = Restaurant.create!(name: "Example Restaurant", description: "testing testing", address: "Hamilton123", phone_number: "000", operating_hours: "never", user_id: user2.id)

# Create a menu item
menu_item = MenuItem.create!(name: "Burger", price: 10.0, description: "this is a burger", restaurant: restaurant, category: 2, calories: 200, spiciness: 0, stock: 11, discount: 1)
menu_item2 = MenuItem.create!(name: "Pasta", price: 5.0, description: "this is pasta", restaurant: restaurant, category: 1, calories: 100, spiciness: 1, stock: 10, discount: 5)

#Create an order
order  = Order.create!(customer: customer, restaurant: restaurant, status: "done", total_price: 30)
orderItem = OrderItem.create!(menu_item: menu_item, quantity: 2, order: order)
orderItem = OrderItem.create!(menu_item: menu_item2, quantity: 1, order: order)






