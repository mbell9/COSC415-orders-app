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

