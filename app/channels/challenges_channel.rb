class ChallengesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "challenges_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end