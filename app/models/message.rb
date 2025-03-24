class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :context, presence: true

  after_create_commit :create_notification

  private

  def create_notification
    Notification.create(user: user, category: "chat", notifiable: self)
  end
end
