# app/controllers/restaurants_controller.rb

class RestaurantsController < ApplicationController
    def new
      @restaurant = Restaurant.new
    end
  
    def index
      @restaurants = Restaurant.all.order(:name)
    end

    def show
      @restaur = Restaurant.find(params[:id])
    end

    def create
      @restaurant = Restaurant.new(restaurant_params)
      if @restaurant.save
        redirect_to @restaurant, notice: 'Restaurant was successfully created.'
      else
        render :new
      end
    end
  
    private
  
    def restaurant_params
      params.require(:restaurant).permit(:name, :description, :address, :phone_number, :operating_hours)
    end
  end
  