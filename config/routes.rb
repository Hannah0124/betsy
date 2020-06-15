Rails.application.routes.draw do
  get 'pages/home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users

  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  root to: "pages#home"
  get "/search", to: "products#search", as: "search"
  get '/frontpage', to: 'pages#frontpage', as: "frontpage"

  patch '/products/:id/toggle_status', to: 'products#toggle_status', as: 'toggle_status'
  get '/dashboard', to: "users#dashboard", as: "dashboard"
  patch '/orderitems/add', to:"orderitems#increase_quantity", as: "add"
  patch '/orderitems/subtract', to:"orderitems#decrease_quantity", as: "subtract"

  resources :products do 
    resources :reviews, only: [:create]
  end

  resources :orderitems, only: [:index, :create, :increase_quantity]
  resources :products
  resources :categories
  resources :orders, only: [:index, :new, :edit]  # TODO
end


# review route - reference: https://stackoverflow.com/questions/25107038/ruby-on-rails-settting-up-reviews-functionality