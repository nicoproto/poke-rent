class Pokemon < ApplicationRecord
  belongs_to :user

  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings
  has_many :kinds_pokemons
  has_many :kinds, through: :kinds_pokemons

  validates :name, :location, :price, :description, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 25 }
end
