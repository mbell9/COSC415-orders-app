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

      if params[:set_restaurant_id] && @cart.restaurant_id != menu_item.restaurant_id && @cart.restaurant_id.nil? == false
          Rails.logger.info "Present Rest ID: #{@cart.restaurant_id}, attempted Rest ID: #{menu_item.restaurant_id}"
          redirect_to customer_menu_path(restaurant_id: menu_item.restaurant_id, show_clear_cart: true), notice: 'You have cart items from another restaurant' and return
      else
        if cart_item.new_record?
          cart_item.quantity = 1
        else
          cart_item.quantity += 1
        end
        cart_item.save

        if params[:set_restaurant_id] && current_user.customer.cart.restaurant_id.nil?

          if @cart.update(restaurant_id: menu_item.restaurant_id)
            Rails.logger.info("SUCCESSFUL UPDATE")
          else
            Rails.logger.info "ERRORS: #{@cart.errors.full_messages}"
          end

          redirect_to customer_menu_path(restaurant_id: menu_item.restaurant_id), notice: "Cart updated to restaurant #{@cart.restaurant_id}"
          return
          # else
          # redirect_to cart_path, notice: "Quantity of #{cart_item.menu_item.name} increased to #{cart_item.quantity}"
        end
        redirect_to request.referer || home_path, notice: "Quantity of #{cart_item.menu_item.name} increased to #{cart_item.quantity}"
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
            redirect_to cart_path, notice: 'Item quantity reduced.'
          else
            redirect_back(fallback_location: root_path, alert: 'Unable to update the item.')
          end
        else
          cart_item.destroy
          redirect_to cart_path, notice: 'Item removed from cart.'
        end
    end


    def destroy
      @cart_item.destroy
      redirect_to cart_path, notice: 'Item removed from cart.'
    end

    private

    def set_cart
        @cart = current_user.customer.cart
    end

  end
