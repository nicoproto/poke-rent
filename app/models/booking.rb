class Booking < ApplicationRecord
  before_create :set_total_price
  after_create :create_chatroom
  after_create :create_notification

  belongs_to :pokemon
  belongs_to :user
  has_one :review, dependent: :destroy
  has_one :chatroom
  has_one :notification, foreign_key: :notifiable_id, dependent: :destroy

  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  enum status: [ :pending, :accepted, :declined ]

  def is_updatable?
    (start_date - Date.today) > 0
  end

  def is_reviewable?
    (Date.today > end_date) && !reviewed?
  end

  def reviewed?
    !self.review.nil?
  end

  def notification_to_s
    "you a booking request"
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

  def create_chatroom
    Chatroom.create(booking: self)
  end

  def create_notification
    Notification.create(
      recipient: pokemon.user,
      actor: user,
      action: 'sent',
      notifiable: self
    )
  end
end
