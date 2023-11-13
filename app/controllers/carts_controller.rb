class CartsController < ApplicationController
    before_action :set_cart, only: [:show]
  
    def show
        @cart = @customer.cart
        @cart_items = @cart.cart_items.includes(:menu_item)
    end
  
    private
    
    def set_cart
        @customer = Customer.find(params[:customer_id])
        @cart = @customer.cart || @customer.create_cart
    end
  end
  
