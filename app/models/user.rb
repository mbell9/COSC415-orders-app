class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # enum role: { customer: 0, owner: 1 }
  has_one :customer
  has_one :restaurant
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
