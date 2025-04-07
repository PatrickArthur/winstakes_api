class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :criteria_for_winning, :judging_method, :finals_judging, :prize_type, :token_prize_percentage, :fixed_token_prize, :product_id, :prize, :creator_id, :video_url, :start_date, :end_date, :duration, :entry_fee, :voting_start_time, :voting_end_time, :entries, :status, :created_at, :updated_at

  belongs_to :creator, serializer: UserSerializer

  has_many :challenge_participants, serializer: ChallengeParticipantSerializer
  has_many :users, through: :challenge_participants
  has_many :judges
  has_many :criteria, class_name: 'Criterion', serializer: CriterionSerializer
  has_many :likes

  def voting_start_time
    object.voting_end_time
  end

  def voting_end_time
    object.voting_end_time
  end

  def status
    object.status
  end

  def duration
    object.duration
  end

  def judges
    object.judges.pluck(:id)
  end

  def video_url
    if object.video.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.video, host: 'localhost:4000')
    else
      nil
    end
  end

   def entries
    object.challenge_participants.map(&:entries).flatten.map do |entry|
      EntrySerializer.new(entry).serializable_hash
    end
  end
end

