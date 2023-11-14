class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :restaurant
  has_many :cart_items
end
