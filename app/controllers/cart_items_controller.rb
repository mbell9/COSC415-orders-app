class CartItemsController < ApplicationController
    before_action :set_cart, only: [:create, :add_to_cart, :remove_from_cart, :destroy]
  
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
      menu_item = MenuItem.find(params[:menu_item_id])
      cart_item = @cart.cart_items.find_or_initialize_by(menu_item: menu_item)
      if cart_item.new_record?
        cart_item.quantity = 1
      else
        cart_item.quantity += 1
      end

      if cart_item.save
        redirect_to @cart, notice: 'Item quantity increased.'
      else
        redirect_to @cart, alert: 'Failed to increase item quantity.'
      end
    end
  
    def remove_from_cart
        menu_item = MenuItem.find(params[:menu_item_id])
        cart_item = @cart.cart_items.find_by(menu_item: menu_item)
      
        if cart_item.nil?
          redirect_back(fallback_location: root_path, alert: 'Item not found in cart.') and return
        end
      
        if cart_item.quantity > 1
          cart_item.quantity -= 1
          if cart_item.save
            redirect_to @cart, notice: 'Item quantity reduced.'
          else
            redirect_back(fallback_location: root_path, alert: 'Unable to update the item.')
          end
        else
          cart_item.destroy
          redirect_to @cart, notice: 'Item removed from cart.'
        end
    end
      
  
    def destroy
      @cart_item.destroy
      redirect_to @cart, notice: 'Item removed from cart.'
    end
  
    private
  
    def set_cart
        @cart = current_user.customer.cart
    end
  
  end
  