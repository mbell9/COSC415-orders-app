class Cart < ApplicationRecord
  belongs_to :customer
  belongs_to :restaurant
  has_many :cart_items
  has_many :menu_items, through: :cart_items
end
