class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  # Ensure a user can only like something once
  validates_uniqueness_of :user_id, scope: [:likeable_type, :likeable_id], message: "can only like once"

  # If you want to make sure each like is associated with a profile:
  belongs_to :profile

  # Validation to ensure combination of user, likeable, and profile is unique
  validates_uniqueness_of :profile_id, scope: [:likeable_type, :likeable_id], message: "can only like once per profile"

  def create_notification
    Notification.create(user: creator, category: "challenge", notifiable: self)
  end
end
