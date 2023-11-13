# spec/models/menu_item_spec.rb

require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price) }
  let(:valid_attributes) {
    {
      name: "Test Item",
      price: 10.0,
      restaurant: FactoryBot.create(:restaurant) # Assuming you have a restaurant factory set up
    }
  }

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

  # Availability and Featured
  it "validates availability to be either true or false" do
    menu_item = build(:menu_item, availability: true)
    expect(menu_item).to be_valid

    menu_item.availability = true
    expect(menu_item).to be_valid

    menu_item.availability = false
    expect(menu_item).to be_valid
  end

  it "validates featured to be either true or false" do
    menu_item = build(:menu_item, featured: true)  # Using the factory ensures that all required attributes are set
    expect(menu_item).to be_valid

    menu_item.featured = true
    expect(menu_item).to be_valid

    menu_item.featured = false
    expect(menu_item).to be_valid
  end

  # Calories
  it "validates calories to be non-negative or nil" do
    menu_item = build(:menu_item, calories: 5)  # Using the factory ensures that all required attributes are set
    expect(menu_item).to be_valid

    menu_item.calories = 5
    expect(menu_item).to be_valid

    menu_item.calories = 0
    expect(menu_item).to be_valid

    menu_item.calories = nil
    expect(menu_item).to be_valid
  end

  # Category and Spiciness
  it "requires a category" do
    menu_item = MenuItem.new(valid_attributes.merge(category: nil))
    expect(menu_item).not_to be_valid
  end

  it "accepts only valid categories" do
    expect {
      MenuItem.new(valid_attributes.merge(category: "invalid_category"))
    }.to raise_error(ArgumentError, "'invalid_category' is not a valid category")
  end

  it "requires spiciness" do
    menu_item = MenuItem.new(valid_attributes.merge(spiciness: nil))
    expect(menu_item).not_to be_valid
  end

  it "accepts only valid spiciness levels" do
    expect {
      MenuItem.new(valid_attributes.merge(spiciness: "invalid_spiciness"))
    }.to raise_error(ArgumentError, "'invalid_spiciness' is not a valid spiciness")
  end

  it "returns true for in_stock? when availability is true and stock is greater than 0" do
    menu_item = build(:menu_item, availability: true, stock: 5)
    expect(menu_item.in_stock?).to be_truthy
  end
  
  it "returns false for in_stock? when availability is false, regardless of stock count" do
    menu_item = build(:menu_item, availability: false, stock: 5)
    expect(menu_item.in_stock?).to be_falsey
  end
  
  it "returns false for in_stock? when stock is 0, even if availability is true" do
    menu_item = build(:menu_item, availability: true, stock: 0)
    expect(menu_item.in_stock?).to be_falsey
  end
  
  it "decreases stock by a given amount" do
    menu_item = create(:menu_item, stock: 5)
    menu_item.decrease_stock(2)
    expect(menu_item.reload.stock).to eq(3)
  end
  
  it "does not decrease stock if the requested amount is more than available stock" do
    menu_item = create(:menu_item, stock: 2)
    menu_item.decrease_stock(5)
    expect(menu_item.reload.stock).to eq(2)
  end

  it "returns discounted price when a discount is present" do
    menu_item = build(:menu_item, price: 100, discount: 10) # 10% off
    expect(menu_item.discounted_price).to eq(90.0)
  end
  
  it "returns original price when no discount is present" do
    menu_item = build(:menu_item, price: 100, discount: nil)
    expect(menu_item.discounted_price).to eq(100.0)
  end
  
  it "sets availability to false when stock reaches 0" do
    menu_item = create(:menu_item, stock: 1)
    menu_item.decrease_stock(1)
    expect(menu_item.reload.availability).to be_falsey
  end
  
  it "sets availability to true when stock is more than 0" do
    menu_item = create(:menu_item, stock: 0, availability: false)
    menu_item.update(stock: 5)
    expect(menu_item.reload.availability).to be_truthy
  end
end

# new edit tests
RSpec.describe "MenuItems", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:menu_item) { create(:menu_item, restaurant: restaurant) }
  let(:valid_attributes) {
    { 
      name: "Updated Item TEST!!!",
      description: "Delicious and spicy",
      category: "main_course", # Assuming your MenuItem model translates this to the appropriate enum value
      spiciness: "medium",     # Same assumption as above
      price: 20.0,
      discount: 0.50,
      stock: 10,
      availability: true
    }
  }
  let(:invalid_attributes) { { name: "", price: "" } }



  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_restaurant_menu_item_path(restaurant, menu_item)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested menu_item" do
        patch restaurant_menu_item_path(restaurant, menu_item), params: { menu_item: valid_attributes }
        menu_item.reload
        expect(menu_item.name).to eq("Updated Item TEST!!!")
        expect(menu_item.price).to eq(20.0)
      end
  
      it "redirects to the menu_item index page" do
        patch restaurant_menu_item_path(restaurant, menu_item), params: { menu_item: valid_attributes }
        menu_item.reload
        expect(response).to redirect_to restaurant_menu_items_path(restaurant)
      end

      it "renders a successful response (i.e., to display the 'edit' template)" do
        patch restaurant_menu_item_path(restaurant, menu_item), params: { menu_item: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:restaurant) { create(:restaurant) }  # Ensure restaurant is created and persisted
    let!(:menu_item) { create(:menu_item, restaurant: restaurant) }  # Create and persist a menu_item associated with the restaurant
    it "destroys the requested menu_item" do
      expect {
        delete restaurant_menu_item_path(restaurant, menu_item)
      }.to change(MenuItem, :count).by(-1)
    end

    it "redirects to the menu_items list" do
      delete restaurant_menu_item_path(restaurant, menu_item)
      expect(response).to redirect_to(restaurant_menu_items_path(restaurant))
    end

    it "sets a flash notice" do
      delete restaurant_menu_item_path(restaurant, menu_item)
      expect(flash[:notice]).to match(/Menu item was successfully destroyed./)
    end
  end
end