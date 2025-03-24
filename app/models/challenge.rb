class Challenge < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :product, optional: true
  has_many :challenge_participants
  has_many :votes
  has_many :users, through: :challenge_participants
  has_many :criteria,  class_name: 'Criterion', dependent: :destroy
  has_one_attached :video
  has_many :likes, as: :likeable

  validates :title, :description, :criteria_for_winning, :duration, presence: true
  validate :unique_challenge, on: :create
  before_save :assign_prize
  validates :prize_type, inclusion: { in: %w(tokens product) } # Corrected syntax for the array
  validates :token_prize_percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }, if: -> { prize_type == "tokens" }
  validates :fixed_token_prize, numericality: { greater_than: 0 }, allow_nil: true # Corrected dot to a comma
  validates :product_id, presence: true, if: -> { prize_type == "product" }
  validate :correct_video_mime_type



  after_create_commit :create_notification
  has_many :wonks, dependent: :destroy
  has_many :judgeships
  has_many :judges, through: :judgeships, source: :user
  after_create :create_wonk

  scope :not_participated_by, ->(user) {
    where.not(id: user.challenges.select(:id))
  }

  scope :participated_in, ->(user) {
    where(id: user.challenges.select(:id))
  }

  scope :not_created_by, ->(user) {
    where.not(creator_id: user.id)
  }

  scope :created_by, ->(user) {
    where(creator_id: user.id)
  }

  def voting_start_time
    end_date
  end

  def voting_end_time
    (end_date || 0) + 72.hours
  end

  def status
    current_time = Time.current

     if start_date.nil?
      return "start date is undefined"
    elsif end_date.nil?
      return "end date is undefined"
    elsif voting_start_time.nil? || voting_end_time.nil?
      return "voting period is undefined"
    end

    if current_time < start_date
      "upcoming"
    elsif current_time >= start_date && current_time < end_date
      "open"
    elsif current_time >= voting_start_time && current_time < voting_end_time
      "voting"
    else
      "closed"
    end
  end

  def duration
    return nil unless start_date && end_date
    ((end_date - start_date) / 1.day).to_i
  end

  def create_notification
    Notification.create(user: creator, category: "challenge", notifiable: self)
  end

  def manage_judges(judge_ids, judging_method)
    # Clear judges if the judging method is not "selection of judges"
    if judging_method != "selectionOfJudges"
      self.judges.clear
      return
    end

    # Get current and new judges
    current_judge_ids = self.judges.pluck(:id)
    judges_to_add = judge_ids - current_judge_ids
    judges_to_remove = current_judge_ids - judge_ids

    # Add new judges
    self.judges << User.where(id: judges_to_add) if judges_to_add.any?

    # Remove judges no longer assigned
    self.judges.delete(User.where(id: judges_to_remove)) if judges_to_remove.any?
  end

  private

  def create_wonk
    wonk = Wonk.create(user: creator, profile: creator.profile, content: "A new challenge was created: #{self.title}", challenge: self)
    cb_wonk = wonk.as_json(include: { user: { only: [:id, :email] } })
    ActionCable.server.broadcast 'wonk_channel', cb_wonk
  end
  
  def unique_challenge
    if Challenge.exists?(title: title, creator_id: creator_id)
      errors.add(:title, 'has already been taken for this creator')
    end
  end

  def assign_prize
    if prize_type == "product" && product.present?
      self.prize = product.name 
    elsif fixed_token_prize.present?
      self.prize = "#{fixed_token_prize} Tokens (Fixed)"
    elsif token_prize_percentage.present?
      self.prize = "#{token_prize_percentage}% of Total Tokens"
    else
      self.prize = "No Prize Specified"
    end
  end

   def correct_video_mime_type
    if video.attached? && !video.content_type.in?(%w[video/mp4 video/quicktime])
      errors.add(:video, 'must be MP4 or MOV')
    end
  end
end