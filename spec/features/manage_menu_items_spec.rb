# spec/features/manage_menu_items_spec.rb
#NOTICE: PLACES WHERE IT GIVES ERROR: "Unknown action\nThe action 'show' could not be found for RestaurantsController"
require 'rails_helper'

RSpec.feature "ManageMenuItems", type: :feature do
  let(:restaurant) { Restaurant.create!(name: "Test Restaurant", address: "123 Test St.", phone_number: "123-456-7890") }
  let!(:menu_item) { MenuItem.create!(name: "Original Item", description: "Original Description", price: 10.99, restaurant: restaurant) }

  it "Restaurant owner creates a new menu item" do
    visit new_restaurant_menu_item_path(restaurant.id)
    fill_in "Menu Item Name", with: "Test Item"
    fill_in "Description", with: "Test Description"
    select "appetizer", from: "Category" # Ensure this line exists and is correct
    fill_in "Price ($)", with: 10.99 
    click_button "Create Menu item"
    expect(page).to have_text("Menu item was successfully created.")
  end
  

  scenario "Restaurant owner tries to create an invalid menu item" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: ""
    fill_in "Price", with: "-5"
    click_button "Create Menu item"

    expect(page).to have_text("Name can't be blank")
    expect(page).to have_text("Price must be greater than 0")
  end

  scenario "Menu item availability updates based on stock" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: "Burger"
    fill_in "Price", with: "7.0"
    fill_in "Stock", with: "5"
    select "appetizer", from: "Category" # Ensure this line exists and is correct
    click_button "Create Menu item"

    menu_item = MenuItem.find_by(name: "Burger")
    expect(menu_item.availability).to be_truthy

    # Simulate the stock going to 0 (perhaps this could be done via some user action)
    menu_item.update(stock: 0)
    expect(menu_item.availability).to be_falsey
  end

  scenario "Menu item displays discounted price" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: "Salad"
    fill_in "Price", with: "5.0"
    fill_in "Discount", with: "10"
    select "appetizer", from: "Category" # Ensure this line exists and is correct
    click_button "Create Menu item"

    expect(page).to have_text("Menu item was successfully created.")
    expect(page).to have_text("Salad")
    expect(page).to have_text("$4.5")  # Discounted price
  end

  scenario "Menu item displays regular price when no discount" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: "Pasta"
    fill_in "Price", with: "8.0"
    select "appetizer", from: "Category" # Ensure this line exists and is correct
    click_button "Create Menu item"

    expect(page).to have_text("Menu item was successfully created.")
    expect(page).to have_text("Pasta")
    expect(page).to have_text("$8.0")  # Regular price
  end

  scenario "Restaurant owner edits an existing menu item" do
    visit edit_restaurant_menu_item_path(restaurant, menu_item)

    fill_in "Menu Item Name", with: "Updated Item"
    fill_in "Description", with: "Updated Description"
    fill_in "Price ($)", with: 12.99
    click_button "Update Menu item"

    expect(page).to have_text("Menu item was successfully updated.")
    expect(page).to have_text("Updated Item")
    expect(page).to have_text("$12.99")
  end
end
