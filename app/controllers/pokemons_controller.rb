class PokemonsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :set_pokemon, only: [:show]

  def index
    @pokemons = Pokemon.all
  end

  def show; end

  def new
    @pokemon = Pokemon.new
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)
    @pokemon.user = current_user

    if @pokemon.save
      redirect_to pokemon_path(@pokemon)
    else
      render :new
    end
  end

  private

  def pokemon_params
    # TODO: Add kinds when ready
    params.require(:pokemon).permit(:name, :description, :price, :location)
  end

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end
end
