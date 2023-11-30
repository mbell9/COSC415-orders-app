# app/controllers/menu_items_controller.rb

class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: [:show, :edit, :update, :destroy]
  before_action :set_restaurant

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

    begin
      @restaurant = Restaurant.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to home_path
      return
    end
    # No changes needed here for now
  end

  # GET /restaurants/:restaurant_id/menu_items/:id/edit
  def edit
  end


  # PATCH/PUT /restaurants/:restaurant_id/menu_items/:id
  def update
    if @menu_item.update(menu_item_params)
      redirect_to restaurant_menu_items_path(@restaurant), notice: 'Menu item was successfully updated.'
    else
      logger.debug @menu_item.errors.full_messages # This will print the errors to your logs
      flash.now[:alert] = @menu_item.errors.full_messages.to_sentence
      render :edit
    end
  end


  def destroy

    begin
      @menu_item = MenuItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to home_path
      return
    end

    Rails.logger.debug "Attempting to destroy menu_item with id: #{params[:id]}"
    if @menu_item.destroy
      Rails.logger.debug "Menu_item destroyed."
      redirect_to restaurant_menu_items_path(@restaurant), notice: 'Menu item was successfully destroyed.'
    else
      Rails.logger.debug "Menu_item could not be destroyed: #{menu_item.errors.full_messages.join(", ")}"
      redirect_to restaurant_menu_items_path(@restaurant), alert: 'Menu item could not be destroyed.'
    end
  end

  def customer_index

    begin
      @restaurant = Restaurant.find(params[:restaurant_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to home_path
      return
    end

    @menu_items = @restaurant.menu_items
  end

  private

  def set_menu_item

    begin
      @menu_item = MenuItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to home_path
      return
    end

  end


  def set_restaurant

    begin
      @restaurant = Restaurant.find(params[:restaurant_id]) if params[:restaurant_id].present?
    rescue ActiveRecord::RecordNotFound
      redirect_to home_path
      return
    end
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :category, :spiciness, :price, :discount, :stock, :availability, :image)
  end

end
