class Kind < ApplicationRecord
  CATEGORIES = %w[electric fire water grass flying poison bug normal ground].freeze

  has_many :kinds_pokemons
  has_many :pokemons, through: :kinds_pokemons

  validates :name, inclusion: { in: CATEGORIES, message: "%{value} is not a valid class" }
end
