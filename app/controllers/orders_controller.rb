class OrdersController < ApplicationController
    before_action :set_orders, only: [:index]
    def index
        @orders = set_orders
    end

    def show

        @order = Order.find(params[:id])
        @order_items = @order.order_items

        if @order.customer != current_user.customer && @order.restaurant != current_user.restaurant
            redirect_to home_path
        end

    end

    def new
        @order = Order.new
    end

    def update_status
        @order = Order.find(params[:id])
        if @order.status == "Picked Up"
            redirect_to orders_path
            return
        elsif @order.status == "Pending"
            @order.update(status: "Order Taken")
            UserMailer.status_update_email(@order, "Your order ##{@order.id} has been received by the restaurant!").deliver_now
        elsif @order.status == "Order Taken"
            @order.update(status: "Being Prepared")
            UserMailer.status_update_email(@order, "Your order ##{@order.id} is being prepared!").deliver_now
        elsif @order.status == "Being Prepared"
            @order.update(status: "Ready for Pickup")
            UserMailer.status_update_email(@order, "Your order ##{@order.id} is ready for pickup!").deliver_now
        elsif @order.status == "Ready for Pickup"
            @order.update(status: "Picked Up", end_time: Time.current.strftime("%Y-%m-%d %H:%M"))
            UserMailer.status_update_email(@order, "Your order ##{@order.id} has been picked up!").deliver_now
        end

         redirect_to orders_path, notice: 'Order status updated successfully.'
    end


    def create
        @order = current_customer.orders.build(order_params)
        @order.restaurant_id = params[:restaurant_id]
        @order.cart_items = current_customer.cart.cart_items

        if @order.save
          # here I need to handle the logic for clearing the cart, setting order status, etc.
          #redirect_to @order, notice: 'Order was successfully placed.'
        else
          render :new
        end
    end

  def set_orders
    if current_user.is_customer?
        Rails.logger.info("CUSTOMER ID: #{current_user.customer.id}")
        @orders = Order.where(customer_id: current_user.customer.id)
    elsif current_user.is_restaurant?
        Rails.logger.info("RESTAURANT ID: #{current_user.restaurant.id}")
        @orders = Order.where(restaurant_id: current_user.restaurant.id)
    else
    end
  end

  def order_params
    params.require(:order).permit(:restaurant_id, :customer_id, :status, :total_price)
  end
end
