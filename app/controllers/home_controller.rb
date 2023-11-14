class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:main]
  def main
    if user_signed_in?
      redirect_to restaurants_path
    end
  end
end
