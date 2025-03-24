class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :profile_id, :user_id, :wonk_id, :created_at, :updated_at, :parent_comment_id, :replies_count

  belongs_to :profile, serializer: ProfileSerializer
  belongs_to :user
  belongs_to :wonk
  has_many :likes

  has_many :replies do
    object.replies.map do |reply|
      ReplySerializer.new(reply).as_json
    end
  end
end