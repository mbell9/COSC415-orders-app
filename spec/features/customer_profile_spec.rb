# # spec/features/customer_profile_feature_spec.rb

# require 'rails_helper'

# RSpec.feature "CustomerProfile", type: :feature do
#   let(:customer) { FactoryBot.create(:customer) }

#   scenario "Customer views their profile" do
#     visit profile_path

#     expect(page).to have_content("Customer Profile")
#     expect(page).to have_content(customer.name)
#     expect(page).to have_content("Email: #{customer.email}")
#     expect(page).to have_content("Phone Number: #{customer.phone_number}")
#     expect(page).to have_content("Address: #{customer.address}")
#     expect(page).to have_link('Edit')  # This checks for the existence of a link with the text 'Edit'

#   end

#   scenario "Customer access the edit page" do
#     visit profile_path

#     click_link 'Edit'
#     sleep 1

#     expect(current_path).to eq(edit_profile_path)

#     # Check the content of the Edit page
#     expect(page).to have_content("Edit Customer Profile")

#     # Check the presence of form fields
#     expect(page).to have_field('Name')
#     expect(page).to have_field('Email')
#     expect(page).to have_field('Phone number')
#     expect(page).to have_field('Address')

#     # Check the presence of buttons
#     expect(page).to have_button('Update Customer')
#     expect(page).to have_link('Back')

#   end

#   scenario "Customer edits their profile with valid input" do
#     visit edit_profile_path

#     fill_in 'Name', with: 'New Name'
#     click_button 'Update Customer'
#     sleep 1

#     expect(current_path).to eq(profile_path)
#     expect(page).to have_content('Customer Profile')
#     expect(page).to have_content('New Name')
#     expect(page).to have_content('Profile updated successfully.')

#   end

#   scenario "Customer edits their profile with invalid input" do
#     visit edit_profile_path

#     fill_in 'Phone number', with: '112132314'
#     click_button 'Update Customer'
#     sleep 1

#     expect(current_path).to eq(profile_path)
#     expect(page).to have_content('Edit Customer Profile')
#     expect(page).to have_content('Phone number is not a valid US phone number')

#   end

#   scenario "Customer edits their profile with valid input and phone num is reformatted" do
#     visit edit_profile_path

#     fill_in 'Phone number', with: '111.222.3333'
#     click_button 'Update Customer'
#     sleep 1

#     expect(current_path).to eq(profile_path)
#     expect(page).to have_content('Customer Profile')
#     expect(page).to have_content('111-222-3333')
#     expect(page).to have_content('Profile updated successfully.')

#   end

#   scenario "Customer goes back to customer profile from edit page" do
#     visit edit_profile_path

#     click_link 'Back'
#     sleep 1

#     expect(current_path).to eq(profile_path)
#     expect(page).to have_content("Customer Profile")
#   end
# end
