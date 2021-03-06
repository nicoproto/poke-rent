class AddLocationToPokemons < ActiveRecord::Migration[6.0]
  def change
    add_column :pokemons, :location, :string
  end
end
