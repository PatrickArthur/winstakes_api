class ChallengeStateTransitionJob < ApplicationJob
  queue_as :default

  def perform(challenge_id, new_status)
    challenge = Challenge.find_by(id: challenge_id)
    return unless challenge

    challenge.update(status: new_status)
    # Broadcast or notify users if needed
  end
end