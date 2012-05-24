GrokLater::Application.routes.draw do

  get "users/show"

  resources :users

  match '/auth/:provider/(:callback)', to: 'sessions#create', as: 'login'
  match '/logout', to: 'sessions#destroy', as: 'logout'
  
  root :to => "home#index"
end
