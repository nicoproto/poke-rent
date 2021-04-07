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

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end

  resources :notifications, only: [:index] do
    collection do
      post :mark_as_read
    end
  end

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
