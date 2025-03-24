class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :user_name, :date_of_birth, :city, :state, :zip_code, :is_judge, :category, :bio ,:interests, :photo_url, :tokens, :followers, :followers_count, :followed_count, :favorite_judge_profiles
  has_many :wonks

  def photo_url
    object.photo.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.photo, only_path: true) : nil
  end

  def wonks
    object.wonks.limit(5).order! 'created_at DESC'  # Example limiting wonks to avoid deep nesting
  end

  def email
    object.user.email.present? ? object.user.email : nil
  end

  def tokens
    object.user.tokens.map { |token| token.value.to_i }.sum
  end

  def favorite_judge_profiles
    object.user.favorite_judge_profiles.map do |profile|
      {
        id: profile.id,
        first_name: profile.first_name,
        last_name: profile.last_name,
        user_name: profile.user_name
      }
    end
  end

  def followers
    object.user.followers.map(&:profile_id)
  end

  def followers_count
    object.user.followers.count
  end

  def followed_count
    object.user.following.count
  end
end