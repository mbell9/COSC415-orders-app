class BrowseController < ApplicationController

  def index
    if current_user.is_restaurant?
      redirect_to home_path
      return
    end

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

    if current_user.is_restaurant?
      redirect_to home_path
      return
    end

    begin
        @restaurant = Restaurant.find(params[:id])
        @reviews = @restaurant.reviews.where.not(customer_id: current_user.customer.id).order(created_at: :desc).limit(5)
        # @reviews = @restaurant.reviews.order(created_at: :desc).limit(5)
        @spec_review = @restaurant.reviews.find_by(customer_id: current_user.customer.id)
        # if !@spec_review.nil?
        #   @reviews.delete(@spec_review)
        # end

        
    rescue ActiveRecord::RecordNotFound
        redirect_to home_path
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
