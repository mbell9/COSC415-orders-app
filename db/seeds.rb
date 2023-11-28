# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



# 5.times do
#   restaurant = FactoryBot.create(:restaurant)
#   3.times do
#     FactoryBot.create(:menu_item, restaurant: restaurant)
#   end
# end


# Helper method to create a user
def create_user(email, password, role)
  User.create!(email: email, password: password, role: role)
end

# Helper method to create a restaurant
def create_restaurant(user, name, description, address, phone, operating_hours)
  user.create_restaurant!(
    name: name,
    description: description,
    address: address,
    phone_number: phone,
    operating_hours: operating_hours
  )
end

# Helper method to create menu items
def create_menu_item(restaurant, name, price, description, category)
  restaurant.menu_items.create!(name: name, price: price, description: description, category: category)
end

# Helper method to create a customer
def create_customer(user, name, phone_number, address)
  c = user.create_customer!(name: name, phone_number: phone_number, address: address)
  c.create_cart!
  return c
end

# Helper method to create a review
def create_review(restaurant, customer, rating, comment)
  restaurant.reviews.create!(customer: customer, rating: rating, comment: comment)
end

def generate_us_phone_number
  "555-#{rand(100..999)}-#{rand(1000..9999)}"
end


rests = []

9.times do |i|
  owner = create_user("owner#{i}@example.com", "password", "owner")

  # Generating a restaurant name that conforms to the validation rules
  restaurant_name = "Restaurant #{i}"

  # Generating a valid address
  address = "#{rand(100..999)} Main St, City, State, #{rand(10000..99999)}"

  # Creating a restaurant with all necessary information
  restaurant = create_restaurant(
    owner,
    restaurant_name,
    "Great food and friendly service.", # Description
    address,
    generate_us_phone_number(),
    "Mon-Fri: 9am - 9pm"
  )
  rests << restaurant

  # Create Menu Items for each restaurant
  5.times do |mi|
    menu_item_name = "Item #{mi}"
    create_menu_item(restaurant, menu_item_name, (mi+1) * 10.0, "Delicious", (mi % 3)+1)
  end
end

# Assign Customers to User and Create Reviews
3.times do |i|
  customer_user = create_user("customer#{i}@example.com", "password", "customer")
  customer = create_customer(customer_user, "Customer #{i}", generate_us_phone_number(), "456 Elm St")

  # Each customer reviews 3 random restaurants
  3.times do
    restaurant = rests.sample
    create_review(restaurant, customer, rand(1..5), "Great food and service!")
  end

end
