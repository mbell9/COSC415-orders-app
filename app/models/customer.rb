class Customer < ApplicationRecord
    has_many :carts, dependent: :destroy
end
