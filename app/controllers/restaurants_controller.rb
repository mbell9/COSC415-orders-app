# app/controllers/restaurants_controller.rb

class RestaurantsController < ApplicationController
  before_action :filter_blank_params, only: [:update]


    def update
      @restaurant = current_user.restaurant

      @restaurant.update(restaurant_params)
      redirect_to profile_path
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
