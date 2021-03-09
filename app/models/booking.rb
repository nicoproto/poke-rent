class Booking < ApplicationRecord
  before_create :set_total_price

  belongs_to :pokemon
  belongs_to :user
  has_one :review, dependent: :destroy

  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  enum status: [ :pending, :accepted, :declined ]

  def is_updatable?
    (start_date - Date.today) > 1
  end

  private

  def duration
    @duration ||= (end_date - start_date).to_i + 1
  end

  def set_total_price
    self.total_price = duration * pokemon.price
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, 'End date must not be before start date')
    end
  end
end
