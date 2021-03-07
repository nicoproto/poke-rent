class PokemonsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @pokemons = Pokemon.all
  end
end
