# app/controllers/menu_items_controller.rb

class MenuItemsController < ApplicationController
  before_action :set_restaurant, only: [:new, :create, :index]
  before_action :set_menu_item, only: [:show, :edit, :update, :destroy]

  def new
    @menu_item = @restaurant.menu_items.build
  end

  def index
    @menu_items = @restaurant.menu_items
  end
  
  def create
    @menu_item = @restaurant.menu_items.build(menu_item_params)
    if @menu_item.save
      redirect_to @restaurant, notice: 'Menu item was successfully created.'
    else
      render :new
    end
  end

  def show
    # No changes needed here for now
  end

  def edit
    # No changes needed here for now
  end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to @menu_item, notice: 'Menu item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to menu_items_url, notice: 'Menu item was successfully destroyed.'
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id]) if params[:restaurant_id].present?
  end

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end
  
  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price)
  end
end
