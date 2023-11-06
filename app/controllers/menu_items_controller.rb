# app/controllers/menu_items_controller.rb

class MenuItemsController < ApplicationController
    def new
      @restaurant = Restaurant.find(params[:restaurant_id])
      @menu_item = @restaurant.menu_items.build
    end

    def index
        @restaurant = Restaurant.find(params[:restaurant_id])
        @menu_items = @restaurant.menu_items
      end
      
  
    def create
      @restaurant = Restaurant.find(params[:restaurant_id])
      @menu_item = @restaurant.menu_items.build(menu_item_params)
      if @menu_item.save
        redirect_to @restaurant, notice: 'Menu item was successfully created.'
      else
        render :new
      end
    end
  
    before_action :set_restaurant

    private

    def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    end
    private
  
    def menu_item_params
      params.require(:menu_item).permit(:name, :description, :price)
    end
  end
  