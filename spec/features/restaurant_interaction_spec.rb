# spec/features/restaurant_interaction_spec.rb

require 'rails_helper'

RSpec.feature "RestaurantInteraction", type: :feature do
  let(:customer) {FactoryBot.create(:customer)}
  let(:restaurant) { FactoryBot.create(:restaurant) }
  let(:menu_item) { FactoryBot.create(:menu_item, restaurant: restaurant) }
  let(:menu_item_attributes) { FactoryBot.attributes_for(:menu_item) }

  before do
    visit new_user_session_path
    fill_in 'Email', with: customer.user.email
    fill_in 'Password', with: customer.user.password
    click_button 'Log in'
  end

  scenario "Viewing a restaurant's menu" do
    visit restaurant_path(restaurant)

    expect(page).to have_text("View Menu")

    click_link 'View Menu'

    expect(page).to have_text("Menu for #{restaurant.name}")

    within("table") do
        expect(page).to have_content("Name")
        expect(page).to have_content("Description")
        expect(page).to have_content("Category")
        expect(page).to have_content("Spiciness")
        expect(page).to have_content("Price")
        expect(page).to have_content("Actions")
    end
  end

  scenario "Submitting a review for a restaurant" do
    visit restaurant_path(restaurant)

    expect(page).to have_text("Add New Review")

    click_link 'Add New Review'

    fill_in 'review[rating]', with: '3'
    fill_in 'review[comment]', with: 'Delicious!'
    
    click_button 'Submit Review'

    expect(page).to have_text('Rating: 3 Stars')
    expect(page).to have_text('Delicious!')
    expect(page).to have_text('Edit Review')
  end

  scenario "Viewing reviews for a restaurant" do
    FactoryBot.create(:review, restaurant: restaurant, comment: 'Delicious!') # Adjust as per your factories

    visit restaurant_reviews_path(restaurant) # Adjust the path as necessary

    expect(page).to have_text('Delicious!')
  end
end
