# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Restaurant.delete_all

Restaurant.create(name: "D&D", description: "Try our new fried dragon.", address: "Forest 310", phone_number: "718-302-4911")
Restaurant.create(name: "Powerful", description: "Feel the power!", address: "Pow 90", phone_number: "962-004-4258")
Restaurant.create(name: "Delish", description: "It's delicious!", address: "Del 25", phone_number: "110-387-9012")
