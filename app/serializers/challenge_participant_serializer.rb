class ChallengeParticipantSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :challenge_id, :profile_id, :profile_name, :user_email, :creator_id, :photo_url, :created_at, :updated_at

  belongs_to :user
  has_many :entries

  def profile_id
    object.user.profile.id
  end

  def profile_name
    "#{object.user.profile.first_name} #{object.user.profile.last_name}"
  end

  def user_email
    object.user.email
  end

  def creator_id
    object.challenge.creator.id
  end

  def photo_url
    object.user.profile.photo.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.user.profile.photo, only_path: true) : nil
  end
end