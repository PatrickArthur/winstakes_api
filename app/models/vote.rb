class Vote < ApplicationRecord
  belongs_to :challenge
  belongs_to :user
  belongs_to :entry

  before_validation :set_default_weight

  validates :challenge_id, uniqueness: { scope: [:user_id, :entry_id] }

  private

  def set_default_weight
    self.weight ||= 1
  end
end
