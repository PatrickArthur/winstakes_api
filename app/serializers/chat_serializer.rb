class ChatSerializer < ActiveModel::Serializer
  attributes :id, :user1_id, :user2_id, :created_at, :updated_at

  has_many :messages

  belongs_to :user1, serializer: UserSerializer
  belongs_to :user2, serializer: UserSerializer

  def messages
    object.messages.order! 'created_at DESC'  # Example limiting wonks to avoid deep nesting
  end
end
