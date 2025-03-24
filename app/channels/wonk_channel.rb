class WonkChannel < ApplicationCable::Channel
  def subscribed
     if params[:challenge_id]
      # Prioritize streaming from the challenge channel if challenge_id is provided
      stream_from "wonk_channel_#{params[:challenge_id]}"
    elsif params[:profile_id]
      # Stream from the profile channel if only profile_id is provided
      stream_from "wonk_channel_#{params[:profile_id]}"
    else
      # Reject the subscription if neither parameter is present
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
