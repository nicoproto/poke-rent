class Order < ApplicationRecord
  belongs_to :user
  belongs_to :pokemon

  monetize :amount_cents
end
