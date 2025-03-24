class WonkSerializer < ActiveModel::Serializer
  attributes :id, :content, :comments_count, :wonk_type, :created_at, :updated_at
  has_many :comments, serializer: CommentSerializer
  belongs_to :profile, serializer: ProfileSerializer
  has_many :likes
  belongs_to :user
  belongs_to :challenge

  def comments
    # Limit and order the comments as intended
    object.comments.order(created_at: :desc).limit(5)
  end

  def created_at
    # Convert to ISO8601 format for consistency
    object.created_at.iso8601
  end

  def updated_at
    # Convert to ISO8601 format for consistency
    object.updated_at.iso8601
  end

  def profile_photo_url
    # Safely navigate to the photo_url
    object.profile&.photo_url
  end
end