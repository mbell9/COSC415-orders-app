require 'rails_helper'

RSpec.feature "Browsing Restaurants" do
  scenario "Viewing list of restaurants" do
    restaurant1 = instance_double("Restaurant", id: 1, name: "Royal Indian Grill")
    restaurant2 = instance_double("Restaurant", id: 2, name: "Main Moon")

    allow(Restaurant).to receive(:all).and_return([restaurant1, restaurant2])

    visit restaurants_path

    expect(page).to have_content("Royal Indian Grill")
    expect(page).to have_content("Main Moon")
  end

  scenario "Viewing individual restaurant" do
    restaurant = instance_double("Restaurant", id: 1, name: "Royal Indian Grill")

    allow(Restaurant).to receive(:find).with("1").and_return(restaurant)

    visit restaurant_path(restaurant)

    expect(page).to have_content("Royal Indian Grill")
  end
end