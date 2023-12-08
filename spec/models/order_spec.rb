# spec/models/order_spec.rb

require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) do
    FactoryBot.create(:order) do |order|
      FactoryBot.create_list(:order_item, 5, order: order)
    end
  end

  describe "Associations" do
    it { should belong_to(:customer) }
    it { should belong_to(:restaurant) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_many(:menu_items).through(:order_items) }
  end

  describe "calculate_total_cents" do
    it "calculates the total cost in cents for the order" do
      total_cents = order.calculate_total_cents
      total = 0
      order.order_items.each do |item|
        total += item.menu_item.price * item.quantity
      end
      expect(total_cents).to eq((total * 100).round)
    end
  end
end
