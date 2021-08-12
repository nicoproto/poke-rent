class Pokemon < ApplicationRecord
  CATEGORIES = %w[electric fire water grass flying poison bug normal ground].freeze
  DEFAULT_IMG = "https://res.cloudinary.com/nico1711/image/upload/v1615475855/pikachu_default.png"

  include PgSearch::Model

  belongs_to :user
  acts_as_taggable_on :tags
  has_one_attached :photo

  monetize :price_cents

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings

  validates :name, :location, :price, :description, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 25 }

  pg_search_scope :search_by_name_description_and_trainer,
    against: [ :name, :description ],
    associated_against: {
      user: [ :nickname ]
    },
    using: {
      tsearch: { prefix: true }
    }

  def short_description
    description[0..85].gsub(/\s\w+\s*$/,'...')
  end

  def all_types
    self.tag_list.map{ |kind| kind.capitalize }.join(", ")
  end

  def main_type
    self.tag_list.first
  end
end
