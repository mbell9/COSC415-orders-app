class CartsController < ApplicationController
    before_action :set_cart, only: [:show]
  
    def show
        @cart = current_user.customer.cart
        @cart_items = @cart.cart_items.includes(:menu_item)
    end
  
    private
    
    def set_cart
        @cart = current_user.customer.cart || @customer.create_cart
    end
  end
  
