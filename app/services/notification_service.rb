class NotificationService
  include Rails.application.routes.url_helpers

  DEFAULT_MESSAGES = {
    challenge_created: "A new challenge has been created",
    post_liked: "%{from_user_name} liked your post",
    challenge_liked: "%{from_user_name} liked your challenge",
    chat_message: "%{from_user_name} sent you a message",
    comment_posted: "%{from_user_name} commented on your post"
  }

  DEFAULT_LINKS = {
    challenge_created: ->(notifiable) { challenge_path(notifiable) },
    post_liked: ->(notifiable) { post_path(notifiable) },
    challenge_liked: ->(notifiable) { challenge_path(notifiable) },
    chat_message: ->(notifiable) { chat_path(notifiable) },
    comment_posted: ->(notifiable) { post_path(notifiable) }
  }

  def initialize(user:, from_user:, category:, notifiable:, message: nil, link: nil)
    @user = user
    @from_user = from_user
    @category = category
    @notifiable = notifiable

    @message = message || format(DEFAULT_MESSAGES[category], from_user_name: @from_user&.name)
    @link = link || default_link_for(category, notifiable)
  end

  def call
    @notification = Notification.create(
      user: @user,
      from_user: @from_user,
      category: @category,
      notifiable: @notifiable,
      message: @message,
      link: @link
    )
    NotificationJob.perform_later(@notification)
  end

  private

  def default_link_for(category, notifiable)
    if DEFAULT_LINKS[category]
      DEFAULT_LINKS[category].call(notifiable)
    else
      root_path  # Fallback to root path if no default link is found
    end
  end

  def default_url_options
    { host: 'localhost', port: 3000 } # Change as needed for production
  end
end