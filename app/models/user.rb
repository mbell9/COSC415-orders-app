class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :customer, dependent: :destroy
  has_one :restaurant, dependent: :destroy
  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :restaurant
  # validates role is required

  def is_customer?
    self.role == 'customer'
  end
  
  def is_restaurant?
    self.role == 'owner'
  end
end
