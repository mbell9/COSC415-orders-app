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
    unless request.headers["Turbo-Frame"]
      redirect_to home_path
      return
    end
    if current_user.is_customer?
      @customer = current_user.customer
      render 'customers/edit'
    elsif
      @restaurant = current_user.restaurant
      render 'restaurants/edit'
    end
  end
end
