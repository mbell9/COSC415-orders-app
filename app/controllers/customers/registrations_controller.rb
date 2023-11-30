class Customers::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # skip_before_action :authenticate_user!, only: [:create, :new, :edit, :update]

  def new
    super do |user|
      user.build_customer
    end
  end

  def create
    super do |user|
      if user.persisted?
        user.customer.create_cart
      end
    end
  end


  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :role, customer_attributes: [:name, :phone_number, :address]])
  end
end
