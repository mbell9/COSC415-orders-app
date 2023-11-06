# app/models/restaurant.rb

class Restaurant < ApplicationRecord
    has_many :menu_items, dependent: :destroy
  
    validates :name, presence: true
    validates :description, presence: true
    validates :address, presence: true
    #validates :phone_number, presence: true
    # ... any other validations you want to include ...
  end
  