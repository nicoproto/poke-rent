class CreateKindsPokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :kinds_pokemons do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :kind, null: false, foreign_key: true

      t.timestamps
    end
  end
end
