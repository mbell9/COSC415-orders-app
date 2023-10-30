class CartItemsController < ApplicationController
    before_action :set_cart, only: [:create, :add_to_cart, :remove_from_cart, :destroy]
    before_action :set_cart_item, only: [:add_to_cart, :remove_from_cart, :destroy]
  
    def create
      menu_item = MenuItem.find(params[:menu_item_id])
      cart_item = @cart.cart_items.find_by(menu_item: menu_item)
  
      if cart_item
        cart_item.quantity += 1
      else
        cart_item = @cart.cart_items.new(menu_item: menu_item, quantity: 1)
      end
  
      if cart_item.save
        redirect_to @cart, notice: 'Item added to cart successfully.'
      else
        redirect_to @cart, alert: 'Failed to add item to cart.'
      end
    end
  
    def add_to_cart
      @cart_item.quantity += 1
      if @cart_item.save
        redirect_to @cart, notice: 'Item quantity increased.'
      else
        redirect_to @cart, alert: 'Failed to increase item quantity.'
      end
    end
  
    def remove_from_cart
      @cart_item.quantity -= 1
      if @cart_item.quantity > 0
        if @cart_item.save
          redirect_to @cart, notice: 'Item quantity decreased.'
        else
          redirect_to @cart, alert: 'Failed to decrease item quantity.'
        end
      elsif @cart_item.quantity == 0
        @cart_item.destroy
        redirect_to @cart, notice: 'Item removed from cart.'
      else
        redirect_to @cart, alert: 'Invalid operation.'
      end
    end
  
    def destroy
      @cart_item.destroy
      redirect_to @cart, notice: 'Item removed from cart.'
    end
  
    private
  
    def set_cart
        @cart = Cart.first || Cart.create
    end
  
    def set_cart_item
      @cart_item = @cart.cart_items.find(params[:id] || params[:cart_item_id])
    end
  end
  