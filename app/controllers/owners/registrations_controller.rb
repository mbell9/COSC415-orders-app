class Owners::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    super do |user|
      user.build_restaurant
    end
  end


  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :role, restaurant_attributes: [:name, :description, :address, :phone_number, :operating_hours]])
  end
end
