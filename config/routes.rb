Rails.application.routes.draw do
  get 'customers/show'
  get 'customers/edit'
  get 'customers/update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

# Health check route
get "up" => "rails/health#show", as: :rails_health_check

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
resources :customers, only: [:show, :edit, :update]

# MenuItems routes
#resources :menu_items, only: [:show, :edit, :update, :destroy]

  # Defines the root path route ("/")
  # root "posts#index"
  resources :restaurants do
    resources :menu_items, only: [:index, :new, :create]
  end

  resources :carts, only: [:show] do
    resources :cart_items, only: [:create, :destroy] do
      member do
        patch :add_to_cart
        patch :remove_from_cart
      end
    end
  end

end
