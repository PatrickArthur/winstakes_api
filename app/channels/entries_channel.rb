class EntriesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "entries"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end