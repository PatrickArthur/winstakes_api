class Comment < ApplicationRecord
  belongs_to :profile
  belongs_to :user
  belongs_to :wonk, counter_cache: true

  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  belongs_to :parent_comment, class_name: 'Comment', optional: true, counter_cache: :replies_count
  has_many :likes, as: :likeable

  after_create_commit :create_notification
  after_create_commit { broadcast_comment }
  after_create_commit { update_comments_count }

  private

  def create_notification
    NotificationService.new(
      user: wonk.user,
      from_user: user,
      category: "other",
      notifiable: self,
      message: "#{user.email} commented on your post: '#{ wonk.content.first(5)}'",
      link: Rails.application.routes.url_helpers.wonk_comment_path(wonk, self)
    ).call
  end

  def broadcast_comment
    serialized_comment = CommentSerializer.new(self).as_json
    ActionCable.server.broadcast 'comments_channel', serialized_comment
  end

  def update_comments_count
    wonk = Wonk.find(self.wonk_id)
    serialized_wonk = WonkSerializer.new(wonk).as_json
    ActionCable.server.broadcast 'wonk_channel', serialized_wonk
  end
end
