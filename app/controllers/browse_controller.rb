class BrowseController < ApplicationController
  def index

      @restaurants = Restaurant.all

      # Sorting logic based on params
      case params[:sort_by]
      when 'location'
        @restaurants = @restaurants.order(address: :asc)
      when 'operating_hours'
        # Sort by time until closing
        @restaurants = @restaurants.sort_by { |restaurant| time_until_closing(restaurant.operating_hours) }
      end
    end

  def show
    begin
        @restaurant = Restaurant.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to restaurants_path
    end
  end

  private

  def time_until_closing(operating_hours)
      # Assuming operating_hours is in the format 'HH:MM - HH:MM'
      _, closing_time_str = operating_hours.split(' - ')
      closing_time = Time.parse(closing_time_str)

      # Calculate time until closing in minutes
      now = Time.now
      time_until_closing = (closing_time - now) / 60

      # Ensure the result is non-negative
      time_until_closing.negative? ? 0 : time_until_closing
    end
end
