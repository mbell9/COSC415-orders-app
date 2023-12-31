class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!(*)
    return if devise_controller?
    redirect_to home_path unless user_signed_in?
  end

  protected

  def after_sign_in_path_for(resource)
    if current_user.is_customer?
      restaurants_path
    elsif current_user.is_restaurant?
      profile_path
    end
  end
end
