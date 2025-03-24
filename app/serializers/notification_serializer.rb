class NotificationSerializer < ActiveModel::Serializer
     attributes :id, :user_id, :from_user_id, :notifiable_type, :notifiable_id, :category, :read, :message, :link, :photo_url, :created_at, :updated_at

     def photo_url
          if object.from_user.profile.photo.attached?
               Rails.application.routes.url_helpers.rails_blob_url(object.from_user.profile.photo, only_path: true)
          else
               asset_path('default-avatar.png')
          end
     end
end