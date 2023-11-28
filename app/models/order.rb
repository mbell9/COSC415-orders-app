class Order < ApplicationRecord
  belongs_to :customer, optional: true #if customer is deleted
  belongs_to :restaurant
  has_many :cart_items #should be order items

end
