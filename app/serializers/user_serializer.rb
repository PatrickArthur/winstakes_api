class UserSerializer < ActiveModel::Serializer
  attributes :id, :profile_id, :email, :created_at, :photo_url

  def created_date
    object.created_at.strftime('%m/%d/%Y') if object.created_at
  end

  def profile_id
    object.profile.present? ? object.profile.id : nil
  end

  def photo_url
    if object.profile.present?
      object.profile.photo.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.profile.photo, only_path: true) : nil
    else
      nil
    end
  end
end
