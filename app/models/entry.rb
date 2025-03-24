class Entry < ApplicationRecord
  belongs_to :challenge_participant
  has_one_attached :file_attachment
  has_one_attached :video_attachment
  has_many_attached :evidence_attachment
  has_many :votes, dependent: :destroy
  has_many :scores, dependent: :destroy

  validates :challenge_participant_id, presence: true, uniqueness: { message: "can only submit one entry per challenge" }

  def vote_count
      # Replace with actual calculation logic
      votes.count || 0  # Assuming there's a votes_count field from vote records
  end

  def weighted_score
    votes.sum(:weight)
  end

  def average_score
    scores.average(:value)
  end
end
