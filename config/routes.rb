Rails.application.routes.draw do
  get 'pages/home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  root to: "pages#home"
  get "/search", to: "pages#search", as: "search"


  patch '/products/:id/toggle_status', to: 'products#toggle_status', as: 'toggle_status'
  get '/dashboard', to: "users#dashboard", as: "dashboard"

  resources :products do 
    resources :reviews, only: [:create]
  end

  resources :categories
  resources :orders, only: [:index]
end
