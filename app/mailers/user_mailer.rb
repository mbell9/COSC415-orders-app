class UserMailer < ApplicationMailer

  def new_order_email(order)
    @order = order
    mail(to: @order.restaurant.user.email, subject: 'You received a new order!')
  end

  def placed_order_email(order)
    @order = order
    mail(to: @order.customer.user.email, subject: 'You placed an order successfully!')
  end

  def status_update_email(order, message)
    @order = order
    mail(to: @order.customer.user.email, subject: message)
  end

end
