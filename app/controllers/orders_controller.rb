class OrdersController < ApplicationController
    def index
        @orders = Order.where(restaurant_id: params[:restaurant_id])
    end

    def show
        @order = Order.find(params[:id])
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

         redirect_to restaurant_orders_path(@order.restaurant), notice: 'Order status updated successfully.'
    end
    def cancel
        @order = Order.find(params[:id])

        @order.update(status: 'Canceled')
        if @order.update(status: 'Canceled')
            redirect_to order_path(@order), notice: 'Order was successfully canceled.'
        else
            redirect_to order_path(@order), alert: 'Failed to cancel the order.'
        end

        # redirect_to order_path(@order), notice: 'Order was successfully canceled.'
    end

    def create
        @order = current_customer.orders.build(order_params)
        @order.restaurant_id = params[:restaurant_id]
        @order.cart_items = current_customer.cart.cart_items

        if @order.save
          # here I need to handle the logic for clearing the cart, setting order status, etc.
          redirect_to @order, notice: 'Order was successfully placed.'
        else
          render :new
        end
    end
    private

  def order_params
    params.require(:order).permit(:restaurant_id, :customer_id, :status, :total_price)
  end
end
