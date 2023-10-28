# spec/features/manage_menu_items_spec.rb

require 'rails_helper'

RSpec.feature "ManageMenuItems", type: :feature do
  scenario "Restaurant owner creates a new menu item" do
    visit new_menu_item_path
    fill_in "Name", with: "Pizza"
    fill_in "Price", with: "10.0"
    click_button "Create Menu item"

    expect(page).to have_text("Menu item was successfully created.")
    expect(page).to have_text("Pizza")
    expect(page).to have_text("$10.0")
  end

  scenario "Restaurant owner tries to create an invalid menu item" do
    visit new_menu_item_path
    fill_in "Name", with: ""
    fill_in "Price", with: "-5"
    click_button "Create Menu item"

    expect(page).to have_text("Name can't be blank")
    expect(page).to have_text("Price must be greater than 0")
  end

  # ... Similar tests for editing and deleting menu items ...
end
