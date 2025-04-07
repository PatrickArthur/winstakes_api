class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :profile, dependent: :destroy
  has_many :campaigns, dependent: :destroy

  has_many :user_issues
  has_many :issues, through: :user_issues

  has_many :user_candidates
  has_many :candidates, through: :user_candidates

  has_many :wonks
  
  validates :email, presence: true, uniqueness: true

  accepts_nested_attributes_for :profile

  has_many :chats_as_user1, class_name: 'Chat', foreign_key: 'user1_id', dependent: :destroy
  has_many :chats_as_user2, class_name: 'Chat', foreign_key: 'user2_id', dependent: :destroy

  has_many :created_challenges, class_name: 'Challenge', foreign_key: 'creator_id'
  has_many :challenge_participants
  has_many :challenges, through: :challenge_participants
  has_many :tokens, dependent: :destroy
  has_many :votes
  has_many :judgeships
  has_many :judged_challenges, through: :judgeships, source: :challenge
  has_many :favorite_judges, dependent: :destroy
  has_many :favorite_judge_profiles, through: :favorite_judges, source: :profile

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  # Passive relationships are those where the user is the one being followed by others
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes
  has_one :wallet

  def is_judge?
    profile&.is_judge
  end

  def active_tokens
    tokens.where('expires_at > ? AND revoked = ?', Time.current, false)
  end

  def chats
    Chat.where("user1_id = ? OR user2_id = ?", id, id)
  end

  has_many :messages, dependent: :destroy

  has_many :notifications, dependent: :destroy
  has_many :comments, dependent: :destroy

  def can_view_challenge?(challenge)
    return true if challenge.creator == self
    challenge_participants.exists?(challenge_id: challenge.id)
  end

  def follow(other_user)
    following << other_user if other_user != self && !following?(other_user)
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def follower?(other_user)
    followers.include?(other_user)
  end
end
