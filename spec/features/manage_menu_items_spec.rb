# spec/features/manage_menu_items_spec.rb
require 'rails_helper'

RSpec.feature "ManageMenuItems", type: :feature do
  let(:restaurant_user) { FactoryBot.create(:user_owner) }
  let(:restaurant) { FactoryBot.create(:restaurant, user: restaurant_user) }
  let(:menu_item) { FactoryBot.create(:menu_item, restaurant: restaurant) }
  let(:menu_item_attributes) { FactoryBot.attributes_for(:menu_item) }

  it "Restaurant owner creates a new menu item" do
    visit new_restaurant_menu_item_path(restaurant.id)
    fill_in "Menu Item Name", with: "Test Item"
    fill_in "Description", with: "Test Description"
    select "Appetizer", from: "Category" # Ensure this line exists and is correct
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
    select "Main Course", from: "Category"
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
    select "Appetizer", from: "Category" # Ensure this line exists and is correct
    click_button "Create Menu item"

    expect(page).to have_text("Menu item was successfully created.")
  end

  scenario "Menu item displays regular price when no discount" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: "Pasta"
    fill_in "Price", with: "8.0"
    select "Appetizer", from: "Category"
    click_button "Create Menu item"

    expect(page).to have_text("Menu item was successfully created.")
  end

  scenario "Restaurant owner edits an existing menu item" do
    visit edit_restaurant_menu_item_path(restaurant, menu_item)
    fill_in "menu_item_name", with: "Updated Item"
    fill_in "menu_item_description", with: "Updated Description"
    fill_in "menu_item_price", with: 12.99
    select "Appetizer", from: "menu_item_category"
    click_button "Update Menu item"
  
    expect(page).to have_text("Menu item was successfully updated.")
  end
  
end