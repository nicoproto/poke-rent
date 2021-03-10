class PokemonsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :set_pokemon, only: [:show, :edit, :update, :destroy]

  def index
    @pokemons = Pokemon.all

    @markers = @pokemons.geocoded.map do |pokemon|
      {
        lat: pokemon.latitude,
        lng: pokemon.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { pokemon: pokemon }),
        image_url: 'https://res.cloudinary.com/nico1711/image/upload/v1615373168/pokeball.webp'
      }
    end
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

  def edit; end

  def update
    @pokemon.update(pokemon_params)

    if @pokemon.save
      redirect_to pokemon_path(@pokemon)
    else
      render :edit
    end
  end

  def destroy
    @pokemon.destroy

    redirect_to pokemons_path
  end

  private

  def pokemon_params
    params.require(:pokemon).permit(:name, :description, :price, :location, :photo, tag_list: [])
  end

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end
end
