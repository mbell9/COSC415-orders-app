# spec/models/menu_item_spec.rb

require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price) }
end
