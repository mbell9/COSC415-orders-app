require 'rails_helper'

RSpec.feature 'Browse Restaurants', type: :feature do
  let(:customer) { FactoryBot.create(:customer) }
  let!(:restaurants) { FactoryBot.create_list(:restaurant, 3) }

  scenario 'User views list of restaurants' do
    visit new_user_session_path
    fill_in 'Email', with: customer.user.email
    fill_in 'Password', with: customer.user.password
    click_button 'Log in'

    expect(page).to have_content 'Browse Restaurants'
    expect(page).to have_css '.restaurant-list'

    restaurants.each do |restaurant|
      expect(page).to have_content(restaurant.name)
      expect(page).to have_content(restaurant.address)
      expect(page).to have_content(restaurant.phone_number)
      expect(page).to have_content(restaurant.operating_hours)
    end

  end

  scenario 'User views details of a restaurant' do
    visit new_user_session_path
    fill_in 'Email', with: customer.user.email
    fill_in 'Password', with: customer.user.password
    click_button 'Log in'

    restaurant = restaurants.first
    visit restaurant_path(restaurant)

    expect(page).to have_content restaurant.name
  end
end
