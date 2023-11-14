class BrowseController < ApplicationController
  def index
    @restaurants = Restaurant.all

  end

  def show
    begin
        @restaurant = Restaurant.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to restaurants_path
    end
  end

end
