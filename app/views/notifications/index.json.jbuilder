json.array @notifications do |notification|
  json.id notification.id
  json.actor notification.actor.nickname
  json.action notification.action
  json.notifiable do
    json.type notification.notifiable.notification_to_s
  end
end