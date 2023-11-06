require 'rails_helper'

RSpec.feature "ManageRestaurants", type: :feature do
  let(:restaurant) { Restaurant.create(name: "Test Restaurant", description: "Yessir", address: "123 Test St.", phone_number: "123-456-7890", operating_hours: "Never") }

  scenario "Restaurant is created" do
    visit new_restaurant_path
    expect(page).to have_text("New Restaurant")
    fill_in "Name", with: "Test Item"
    fill_in "Description", with: "Test Description"
    fill_in "Address", with: "Test address" 
    click_button "Create Restaurant"
    expect(page).to have_text("Details for")
  end

  scenario "Restaurant is not created" do
    visit new_restaurant_path
    expect(page).to have_text("New Restaurant")
    fill_in "Name", with: "Test Item"
    fill_in "Description", with: "Test Description"
    click_button "Create Restaurant"
    expect(page).to have_text("Details for")
  end
end