class ReviewsController < ApplicationController

    def index
        @restaurant = Restaurant.find(params[:restaurant_id])
        @reviews = @restaurant.reviews
    end

    def new
        @restaurant = Restaurant.find(params[:restaurant_id])
        @review = @restaurant.reviews.build
    end

    def create
        @restaurant = Restaurant.find(params[:restaurant_id])
        @review = @restaurant.reviews.build(review_params)
        @review.customer = Customer.find(1)
        if @review.save
          redirect_to restaurant_reviews_path(@restaurant)
        else
          render 'new'
        end
    end

    private

    def review_params
        params.require(:review).permit(:rating, :comment)
    end
end
