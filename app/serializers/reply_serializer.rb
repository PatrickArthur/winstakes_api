class ReplySerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at
  
  belongs_to :profile, serializer: ProfileSerializer
  belongs_to :user
  belongs_to :wonk
end