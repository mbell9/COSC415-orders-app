# app/models/menu_item.rb

class MenuItem < ApplicationRecord
    belongs_to :restaurant
  
    validates :name, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
  end
  