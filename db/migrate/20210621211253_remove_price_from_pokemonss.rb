class RemovePriceFromPokemonss < ActiveRecord::Migration[6.0]
  def change
    remove_column :pokemons, :price
  end
end
