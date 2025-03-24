class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :from_user, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  after_create_commit :broadcast_notification

  def broadcast_notification
    NotificationsChannel.broadcast_to(user, {
      message: "You have a new notification",
      notification: self
    })
  end
end
