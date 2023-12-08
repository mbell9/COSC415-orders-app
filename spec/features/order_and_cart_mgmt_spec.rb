require 'rails_helper'

RSpec.feature "OrderAndCartManagement", type: :feature do
  
  let(:menu_item) { FactoryBot.create(:menu_item) }
  let(:restaurant) { menu_item.restaurant }
  let(:cart) { FactoryBot.create(:cart, restaurant: restaurant) }
  let(:customer) { cart.customer }

  let(:menu_item_attributes) { FactoryBot.attributes_for(:menu_item) }

  before do
    visit new_user_session_path
    fill_in 'Email', with: customer.user.email
    fill_in 'Password', with: customer.user.password
    click_button 'Log in'
  end

  scenario "Adding menu items to cart and checking cart contents" do
    restaurant
    visit restaurant_path(restaurant)

    expect(page).to have_text("View Menu")
    click_link 'View Menu'
    expect(page).to have_text("Add to Cart")
    click_button 'Add to Cart'

    visit cart_path

    expect(page).to have_content(menu_item.name)
    expect(page).to have_content('Checkout') # Verify the presence of a checkout button
  end

  scenario "Checking the existence of an order" do
    order = FactoryBot.create(:order, customer: customer, restaurant: restaurant)

    visit order_path(order) # Adjust this to your application's order detail path

    expect(page).to have_content(order.id)
    expect(page).to have_content(order.total_price)
    # Add more assertions to verify order details
  end
end
