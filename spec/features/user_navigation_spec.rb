require 'rails_helper'

RSpec.feature "UserNavigation", type: :feature do
  let(:customer) {FactoryBot.create(:customer)}
  let(:restaurant) { FactoryBot.create(:restaurant) }

  scenario "Customer user signs in" do
    visit new_user_session_path
    fill_in 'Email', with: customer.user.email
    fill_in 'Password', with: customer.user.password
    click_button 'Log in'

    expect(page).to have_current_path(restaurants_path)
  end

  scenario "Restaurant user signs in" do
    visit new_user_session_path
    fill_in 'Email', with: restaurant.user.email
    fill_in 'Password', with: restaurant.user.password
    click_button 'Log in'

    expect(page).to have_current_path(profile_path)
  end
end
