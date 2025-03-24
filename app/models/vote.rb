class Vote < ApplicationRecord
  belongs_to :challenge
  belongs_to :user
  belongs_to :entry

  validates :challenge_id, uniqueness: { scope: [:user_id, :entry_id] }
end
