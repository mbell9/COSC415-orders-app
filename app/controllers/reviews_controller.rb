class ReviewsController < ApplicationController

    def index

        begin
            @restaurant = Restaurant.find(params[:restaurant_id])
        rescue ActiveRecord::RecordNotFound
            redirect_to home_path
            return
        end
        @reviews = @restaurant.reviews
    end

    def new
        begin
            @restaurant = Restaurant.find(params[:restaurant_id])
        rescue ActiveRecord::RecordNotFound
            redirect_to home_path
            return
        end

        # @review = @restaurant.reviews.build
        existing_review = @restaurant.reviews.find_by(customer_id: current_user.customer.id)
        if existing_review
            # If a review by the current user already exists, redirect back with a notice
            redirect_to restaurant_path(@restaurant), alert: "You have already reviewed this restaurant."
        else
            @review = @restaurant.reviews.build
        end
    end

    def create
        begin
            @restaurant = Restaurant.find(params[:restaurant_id])
        rescue ActiveRecord::RecordNotFound
            redirect_to home_path
            return
        end

        @review = @restaurant.reviews.build(review_params)

        @review.customer = Customer.find_by(user_id: current_user.id)
  
        if @review.customer.nil?
            redirect_to home_path
            return
        end
        # begin
        #     @review.customer = Customer.find_by(user_id: current_user.id)
        # rescue ActiveRecord::RecordNotFound
        #     redirect_to home_path
        #     return
        # end
        if @review.save
        #   redirect_to restaurant_reviews_path(@restaurant)
            redirect_to restaurant_path(@review.restaurant_id)
        else
          render 'new'
        end
    end

    def edit
        # Corrected the typo from 'rastaurant_id' to 'restaurant_id'
        @review = Review.find_by(customer_id: current_user.customer.id, restaurant_id: params[:restaurant_id])
      
        if @review
          @restaurant = @review.restaurant
        else
          # Handling the case where the review is not found
          # You can redirect to another page or show an error message
          # For example, redirecting back to the restaurant's page with a notice:
          flash[:alert] = "Review not found."
          redirect_to restaurants_path # Adjust the redirection path as per your routes
        end
      end
      

    def update
        @review = Review.find_by(customer_id: current_user.customer.id, restaurant_id: params[:restaurant_id])
        if @review.update(review_params)
          redirect_to restaurant_path(@review.restaurant_id), notice: 'Review was successfully updated.'
        else
          render :edit
        end
    end
    private

    def review_params
        params.require(:review).permit(:rating, :comment)
    end
end
