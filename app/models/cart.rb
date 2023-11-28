class Cart < ApplicationRecord
  belongs_to :customer
  belongs_to :restaurant, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :menu_items, through: :cart_items
end
