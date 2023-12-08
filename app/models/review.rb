class Review < ApplicationRecord
  belongs_to :customer
  belongs_to :restaurant

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true
  validates :customer, presence: true
  validates :restaurant, presence: true

  before_create :set_recorded_date

  private

  def set_recorded_date
    self.recorded_date ||= Date.today
  end
end
