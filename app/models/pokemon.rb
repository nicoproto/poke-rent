class Pokemon < ApplicationRecord
  CATEGORIES = %w[electric fire water grass flying poison bug normal ground].freeze

  belongs_to :user
  acts_as_taggable_on :tags

  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings

  validates :name, :location, :price, :description, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 25 }
end
