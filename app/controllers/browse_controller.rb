class BrowseController < ApplicationController

  def index
    if current_user.is_restaurant?
      redirect_to home_path
      return
    end

    session[:sorted_by_location] = !session[:sorted_by_location] if params[:toggle_sort] == 'location'
  
    @restaurants = Restaurant.all

    if session[:sorted_by_location]
      @restaurants = @restaurants.order('address ASC')
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

  def total_weekly_operating_hours(operating_hours)
    # Assuming format: 'Mon-Fri: 9am - 9pm'
    days, hours = operating_hours.split(': ')
    start_day, end_day = days.split('-').map { |day| Date::DAYNAMES.index(day.strip) }
    start_time, end_time = hours.split(' - ')
  
    # Convert times to 24-hour format
    start_hour = Time.parse(start_time).hour
    end_hour = Time.parse(end_time).hour
  
    # Adjust for overnight schedules
    end_hour += 24 if end_hour < start_hour
  
    # Calculate daily hours
    daily_hours = end_hour - start_hour
  
    # Adjust for week wrap-around
    total_days = start_day <= end_day ? (end_day - start_day + 1) : (7 - start_day + end_day + 1)
  
    total_days * daily_hours
  rescue
    0 # Return 0 if there's any issue with parsing
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
