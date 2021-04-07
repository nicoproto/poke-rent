class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(notification_id, count)
    notification = Notification.find(notification_id)
    html = ApplicationController.render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.action}", locals: {notification: notification}, formats: [:html]
    puts "notifications:#{notification.recipient_id}"
    ActionCable.server.broadcast "notifications:#{notification.recipient_id}", notification: html, count: count
  end
end
