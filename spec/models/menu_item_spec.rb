# spec/models/menu_item_spec.rb

require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price) }

  it "is valid with valid attributes" do
    expect(build(:menu_item)).to be_valid
  end

  it "is not valid without a name" do
    menu_item = build(:menu_item, name: nil)
    expect(menu_item).not_to be_valid
  end

  it "is not valid without a price" do
    menu_item = build(:menu_item, price: nil)
    expect(menu_item).not_to be_valid
  end

  it "belongs to a restaurant" do
    association = described_class.reflect_on_association(:restaurant)
    expect(association.macro).to eq :belongs_to
  end
end
