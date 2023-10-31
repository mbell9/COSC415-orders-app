require 'rails_helper'

# RSpec.describe Review, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
RSpec.describe Review, type: :model do
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:comment) }
  it { should validate_numericality_of(:rating) }

  let(:valid_attributes) {
    {
      rating: 5,
      comment: "Great food!",
      restaurant: FactoryBot.create(:restaurant),  # Assuming we have a restaurant factory set up
      customer: FactoryBot.create(:customer)      # Assuming we have a customer factory set up
    }
  }

  it "is not valid without restaurant or customer" do
    expect(build(:review)).not_to be_valid
  end

  it "is not valid without a rating" do
    review = build(:review, rating: nil)
    expect(review).not_to be_valid
  end

  it "is not valid without a comment" do
    review = build(:review, comment: nil)
    expect(review).not_to be_valid
  end

  it "belongs to a restaurant" do
    association = described_class.reflect_on_association(:restaurant)
    expect(association.macro).to eq :belongs_to
  end

  it "belongs to a customer" do
    association = described_class.reflect_on_association(:customer)
    expect(association.macro).to eq :belongs_to
  end


end