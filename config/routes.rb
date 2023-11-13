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
get 'restaurants', to: 'browse#index'
get 'restaurants/:id', to: 'browse#show', as: :restaurant

# Restaurant routes with nested resources for menu_items and reviews
resources :restaurants do
  resources :menu_items, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :reviews, only: [:index, :new, :create, :edit, :update, :destroy]
end

# Customer routes
resources :customers, only: [:show, :edit, :update] do
  resource :cart, only: [:show]
end
# MenuItems routes
#resources :menu_items, only: [:show, :edit, :update, :destroy]

  # Defines the root path route ("/")
  # root "posts#index"
  resources :restaurants do
    resources :menu_items, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :reviews, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  get 'restaurants/:restaurant_id/customer_menu', to: 'menu_items#customer_index', as: :customer_menu
  post 'add_to_cart/:menu_item_id', to: 'cart_items#add_to_cart', as: :add_to_cart
  patch 'remove_from_cart/:menu_item_id', to: 'cart_items#remove_from_cart', as: :remove_from_cart


end
