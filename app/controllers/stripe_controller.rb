class StripeController < ApplicationController
    skip_before_action :authenticate_user!, only: [:callback]

    def callback

        begin
            user = User.find_by(id: session[:user_id_for_stripe])
        rescue ActiveRecord::RecordNotFound
            redirect_to home_path
            return
        end

        response = Stripe::OAuth.token({
          grant_type: 'authorization_code',
          code: params[:code],
        })

        Rails.logger.info("STRIPE ID: #{response.stripe_user_id}")
        # Assuming the current user's restaurant needs to be updated
        if user && user.restaurant.update(stripe_account_id: response.stripe_user_id)
            redirect_to root_path, notice: "Successfully connected Stripe and created restuarant"
        end
        session.delete(:user_id_for_stripe)
    end

end
