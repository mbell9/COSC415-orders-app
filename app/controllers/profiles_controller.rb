class ProfilesController < ApplicationController
  def show
    if current_user.is_customer?
      @customer = current_user.customer
      render 'customers/show'
    elsif current_user.is_restaurant?
      @restaurant = current_user.restaurant
      render 'restaurants/profile'
    end
  end

  def edit
    if current_user.is_customer?
      @customer = current_user.customer
      render 'customers/edit'
    end
  end
end
