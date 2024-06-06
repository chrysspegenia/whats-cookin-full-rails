Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # resources :recipes

  root to: 'redirect#index'

  resources :dashboard

  resources :edamam, only: [:index, :show] do
    collection do
      post :save_recipe
    end
  end

  resources :meal_planner, only: [:index, :create, :destroy]

  # get "search" => "edamam#search"
  resources :recipes, param: :title
  post 'recipes/:title/save_ingredient', to: 'recipes#save_ingredient', as: 'save_ingredient'

  resources :spoonacular, only: [:index]
  # resources :inventories, only: [:index]
  get 'myinventory', to: 'inventories#myinventory'
  
  get 'myrecipes', to: 'recipes#user_recipes'
  resources :recipes, only: [:index, :show, :new, :create]

  resources :inventories do
    resources :ingredients do 
      member do
        patch :decrease
        patch :increase
      end
    end
  end
end
