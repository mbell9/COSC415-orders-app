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


  def update
    @customer = current_user.customer

    @customer.update(customer_params)
    redirect_to profile_path
  end


  def customer_params
    params.require(:customer).permit(:name, :phone_number, :address)
  end

  def filter_blank_params
    params[:customer].each do |key, value|
      params[:customer][key] = current_user.customer[key] if value.blank?
    end
  end
end
