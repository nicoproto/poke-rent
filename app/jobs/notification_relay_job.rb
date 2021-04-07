class NotificationRelayJob < ApplicationJob
  queue_as :default

  # def perform(*args) <- Removed the args because we don't need them yet
  def perform
    puts "I'm starting the fake job"
    sleep 3
    puts "OK I'm done now"
  end
end
