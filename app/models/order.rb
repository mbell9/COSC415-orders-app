class Order < ApplicationRecord
  belongs_to :customer#, optional: true #if customer is deleted
  belongs_to :restaurant
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items
end
