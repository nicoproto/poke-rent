class Notification < ApplicationRecord
  after_commit -> { NotificationRelayJob.perform_later(self.id, count) }

  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }

  private

  def count
    recipient.notifications.unread.size
  end
end
