class CartsController < ApplicationController
    before_action :set_cart, only: [:show]
  
    def show
        @cart = Cart.find(params[:id])
        @cart_items = @cart.cart_items.includes(:menu_item)
    end
  
    private
  
    def set_cart
        @cart = Cart.find(1);
    end
  end
  
