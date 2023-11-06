require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:address) }

  it "is valid with valid attributes" do
    expect(build(:restaurant)).to be_valid
  end

  it "is not valid without a name" do
    #profile = build(:restaurant_profile, name: nil)
    #expect(profile).not_to be_valid
    rp = Restaurant.create(name: "D&D", description: "Try our new fried dragon.", address: "Forest 310", phone_number: "718-302-4911", operating_hours: "7AM-8PM")
    expect(rp.name).not_to eq(nil)
  end

  it "should have description" do 
    rp = Restaurant.new 
    rp.description = "Mmmmmm. It's tasty."
    expect(rp.description).not_to eq(nil)
  end

  it "should have address" do 
    rp = Restaurant.new 
    rp.address = "Test"
    expect(rp.address).not_to eq(nil)
  end

  # Operating hours and phone number may be nil 

end
