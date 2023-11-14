class CustomersController < ApplicationController
  before_action :filter_blank_params, only: [:update]

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to customer_path(@customer), notice: "Profile updated successfully."
    else
      flash.now[:error] = @customer.errors.full_messages.join(", ")
      render :edit
    end
  end

  def customer_params
    params.require(:customer).permit(:name, :phone_number, :address)
  end

  def filter_blank_params
    params[:customer].each do |key, value|
      params[:customer].delete(key) if value.blank?
    end
  end
end
