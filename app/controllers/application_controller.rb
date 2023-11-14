class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    redirect_to home_path unless user_signed_in?
  end

  protected

  def after_sign_in_path_for(resource)
    restaurants_path
  end
end
