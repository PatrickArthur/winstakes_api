class MessageSerializer
  include JSONAPI::Serializer
  attributes :id, :chat_id, :user_id, :context, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
end
