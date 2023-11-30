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

        @review = @restaurant.reviews.build
    end

    def create
        begin
            @restaurant = Restaurant.find(params[:restaurant_id])
        rescue ActiveRecord::RecordNotFound
            redirect_to home_path
            return
        end

        @review = @restaurant.reviews.build(review_params)
        begin
            @review.customer = Customer.find(1)
        rescue ActiveRecord::RecordNotFound
            redirect_to home_path
            return
        end
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
