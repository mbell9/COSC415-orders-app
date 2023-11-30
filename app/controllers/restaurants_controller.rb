# app/controllers/restaurants_controller.rb

class RestaurantsController < ApplicationController
  before_action :filter_blank_params, only: [:update]

    # def new
    #   @restaurant = Restaurant.new
    # end

    # def create
    #   @restaurant = Restaurant.new(restaurant_params)
    #   if @restaurant.save
    #     redirect_to @restaurant, notice: 'Restaurant was successfully created.'
    #   else
    #     render :new
    #   end
    # end

    # private

    # def restaurant_params
    #   params.require(:restaurant).permit(:name, :description, :address, :phone_number, :operating_hours)
    # end



    def update
      @restaurant = current_user.restaurant

      if @restaurant.update(restaurant_params)
        flash.now[:notice] = "Profile updated successfully."
        redirect_to profile_path
      else
        flash.now[:error] = @customer.errors.full_messages.join(", ")
        redirect_to profile_path
      end
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :phone_number, :address, :description, :operating_hours)
    end

    def filter_blank_params
      params[:restaurant].each do |key, value|
        params[:restaurant][key] = current_user.restaurant[key] if value.blank?
      end
    end

  end
