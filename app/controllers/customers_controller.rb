class CustomersController < ApplicationController
  before_action :filter_blank_params, only: [:update]

  def show
    if current_user.is_restaurant?
      begin
        @customer = Customer.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to home_path
      end
    else
      redirect_to profile_path
    end

  end

  def edit
    @customer = current_user.customer
  end


  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to profile_path, notice: "Profile updated successfully."
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
