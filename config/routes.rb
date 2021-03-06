Rails.application.routes.draw do
  devise_for :users
  root to: 'pokemons#index'
  resources :pokemons, except: :index
end
