class Order < ApplicationRecord
  belongs_to :customer#, optional: true #if customer is deleted
  belongs_to :restaurant
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items

  def calculate_total_cents
    total = 0
    order_items.each do |order_item|
        total += order_item.menu_item.price * order_item.quantity
    end
    (total * 100).round
  end
end
