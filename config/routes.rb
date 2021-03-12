Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'kitchensink', to: 'pages#kitchensink'

  resources :pokemons do
    resources :bookings, only: [:new, :create]
  end
  resources :bookings, only: [:destroy, :show, :update] do
    resources :reviews, only: [:new, :create]
  end
  resource :dashboard, only: [:show]
  resources :reviews, only: [:edit, :update]
end
