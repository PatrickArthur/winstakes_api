class ChallengeParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  has_many :entries

  before_destroy :remove_orphan_entries

  private

  def remove_orphan_entries
    entries.each do |entry|
      entry.destroy
    end
  end
end