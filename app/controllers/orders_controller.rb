class OrdersController < ApplicationController
    before_action :set_orders, only: [:index]
    def index
        @orders = set_orders
    end

    def show
        @order = Order.find(params[:id])
        @order_items = @order.order_items
    end

    def new
        @order = Order.new
    end

    def update_status
        @order = Order.find(params[:id])
        if @order.status == nil || @order.status == "None"
            @order.update(status: "Order Taken")
        elsif @order.status == "Order Taken"
            @order.update(status: "In Progress")
        elsif @order.status == "In Progress"
            @order.update(status: "Complete!")
        else
            @order.update(status: "None")
        end
         # Change this to your desired logic

         #redirect_to restaurant_orders_path(@order.restaurant), notice: 'Order status updated successfully.'
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
        Rails.logger.info("RESTAURANT ID: #{current_user.customer.id}")
        @orders = Order.where(restaurant_id: current_user.restaurant.id)
    else
    end
  end

  def order_params
    params.require(:order).permit(:restaurant_id, :customer_id, :status, :total_price)
  end
end
