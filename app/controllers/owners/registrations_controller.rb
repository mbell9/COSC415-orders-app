class Owners::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # skip_before_action :authenticate_user!, only: [:create, :new, :edit, :confirm]

  def new
    super do |user|
      user.build_restaurant
    end
  end

  def create
    super do |user|
      if user.persisted? && user.role == 'owner'
        # User is successfully created and not a session user
        session[:user_id_for_stripe] = user.id
        set_onboard_url  # Call the method to set the Stripe URL
        redirect_to @stripe_url, allow_other_host: true and return # Redirect to Stripe onboarding
      end
    end
  end


  def generate_stripe_onboarding_link
    stripe_client_id = Rails.application.credentials.stripe[:client_id]
    redirect_uri = "#{root_url}stripe_callback"
    state_value = SecureRandom.hex(15)
    session[:oauth_state] = state_value

    # Construct the Stripe authorization URL manually
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{stripe_client_id}&scope=read_write&redirect_uri=#{CGI.escape(redirect_uri)}&state=#{CGI.escape(state_value)}"
  end

  def set_onboard_url
    @stripe_url = generate_stripe_onboarding_link
  end


  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :role, restaurant_attributes: [:name, :description, :address, :phone_number, :operating_hours]])
  end
end
