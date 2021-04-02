class NotificationsController < ApplicationController
  before_action :set_notifications

  def index; end

  def mark_as_read
    @notifications.update_all(read_at: Time.zone.now)
    render json: { sucess: true }, status: :ok
  end

  private

  def set_notifications
    # TODO: Try current_user.notifications.unread
    @notifications = Notification.where(recipient: current_user).unread
  end
end
