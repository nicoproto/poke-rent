class Review < ApplicationRecord
  belongs_to :booking
  has_one :user, through: :booking

  validates :rating, inclusion: { in: 1..5, message: "Rating should be between 1 to 5" }
  validates :content, length: { minimum: 25 }
end
