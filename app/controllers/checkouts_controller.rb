class CheckoutsController < ApplicationController
    before_action :set_cart

    def create
        begin
            session = Stripe::Checkout::Session.create(
                payment_method_types: ['card'],
                line_items: prepare_line_items,
                mode: 'payment',
                success_url: checkout_success_url,
                cancel_url: checkout_cancel_url
            )
            redirect_to session.url, allow_other_host: true
        rescue Stripe::StripeError => e
            flash[:error] = e.message
            redirect_to cart_path
        end
    end

    def prepare_line_items
        @cart.cart_items.map do |item|
            {
                price_data: {
                    currency: 'usd',
                    product_data: {
                        name: item.menu_item.name,
                    # Optionally add other product details here
                    },
                    unit_amount: (item.menu_item.price * 100).to_i,  # Convert to cents
                },
                quantity: item.quantity
            }
        end
    end

    def checkout_success_url
        success_checkout_url
    end

    def checkout_cancel_url
        cancel_checkout_url
    end

    def success
        order = Order.create!(customer_id: current_user.customer.id, restaurant_id: @cart.restaurant_id, status: "pending")

        @cart.cart_items.each do |cart_item|
            order.order_items.create!(
                menu_item_id: cart_item.menu_item_id,
                quantity: cart_item.quantity
            )
        end
        @cart.clear_cart
        redirect_to home_path, notice: 'Order was successful!'
    end

    def cancel
    end
    
    private

    def set_cart
        @cart = current_user.customer.cart
    end


end
