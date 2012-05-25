GrokLater::Application.routes.draw do

  resources :subjects

  get '/bookmarklet', to: 'bookmarklet#index', as: 'bookmarklet'
  get '/bookmarklet/start', to: 'bookmarklet#start', as: 'bookmarklet_start'
  get '/bookmarklet/add', to: 'bookmarklet#add', as: 'bookmarklet_add'

  resources :users

  match '/auth/:provider/(:callback)', to: 'sessions#create', as: 'login'
  match '/logout', to: 'sessions#destroy', as: 'logout'
  
  root :to => 'home#index'
end
