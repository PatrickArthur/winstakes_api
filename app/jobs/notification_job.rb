class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    NotificationsChannel.broadcast_to(notification.user, {
      message: "You have a new notification",
      notification: {
        category: notification.category,
        message: notification.message,
        link: notification.link,
        from_user: notification.from_user.try(:name) # Adjust as per your model's association
      }
    })
  end
end