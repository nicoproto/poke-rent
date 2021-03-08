Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :pokemons do
    resources :kinds_pokemons, only: [ :new, :create ]
  end
end
