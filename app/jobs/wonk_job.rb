class WonkJob < ApplicationJob
  queue_as :default

  def perform(wonk)
    # Define your job's task here
    serializer = WonkSerializer.new(wonk)
    serialized_data = ActiveModelSerializers::Adapter.create(serializer).as_json
    channel_name = wonk.challenge_id.present? ? "wonk_channel_#{wonk.challenge_id}" : "wonk_channel_#{wonk.user.profile.id}"
    ActionCable.server.broadcast channel_name, serialized_data
  end
end