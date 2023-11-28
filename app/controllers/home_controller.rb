class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:main]
  def main
    if user_signed_in? && current_user.is_customer?
      redirect_to restaurants_path
    elsif user_signed_in? && current_user.is_restaurant?
      redirect_to profile_path
    end
  end
end
