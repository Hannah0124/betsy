Rails.application.routes.draw do
  get 'pages/home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  root to: "pages#home"
  get "/search", to: "pages#search", as: "search"

  resources :products
  resources :categories

  patch '/products/:id/toggle_status', to: 'products#toggle_status', as: 'toggle_status'
end
