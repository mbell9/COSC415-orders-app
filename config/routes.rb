Rails.application.routes.draw do
  # Devise routes for User
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # Health check route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Root route
  root 'browse#index'

  # Browse routes
  resources :browse, only: [:index, :show]
  
  # Restaurant routes with nested resources for menu_items and reviews
  resources :restaurants do
    resources :menu_items, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :reviews, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  # Customer routes
  resources :customers, only: [:show, :edit, :update]

  # Cart routes with nested cart_items
  resources :carts, only: [:show] do
    resources :cart_items, only: [:create, :destroy] do
      member do
        patch :add_to_cart
        patch :remove_from_cart
      end
    end
  end
end
