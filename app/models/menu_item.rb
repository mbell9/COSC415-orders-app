# app/models/menu_item.rb

class MenuItem < ApplicationRecord
  belongs_to :restaurant
  
  enum category: { appetizer: 0, main_course: 1, dessert: 2, beverage: 3 }
  enum spiciness: { mild: 0, medium: 1, spicy: 2, very_spicy: 3 }

  has_one_attached :image  # Using ActiveStorage for images

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :availability, inclusion: { in: [true, false] }
  validates :featured, inclusion: { in: [true, false] }
  validates :calories, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :category, presence: true
  # Removed the mandatory presence validation for spiciness to make it optional
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_blank: true

  scope :featured_items, -> { where(featured: true) }
  scope :available_items, -> { where(availability: true) }

  before_save :update_availability_based_on_stock

  def in_stock?
    availability && stock.to_i > 0
  end

  def decrease_stock(amount = 1)
    update(stock: stock - amount) if stock && stock >= amount
  end

  def discounted_price
    if discount.present? && discount > 0
      price * ((100 - discount) / 100.0)
    else
      price
    end
  end

  private

  def update_availability_based_on_stock
    self.availability = stock && stock > 0
  end
end