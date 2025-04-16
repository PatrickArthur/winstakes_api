class EntrySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :file_attachment, :video_attachment, :evidence_attachment_urls, :vote_count, :challenge, :weighted_score, :voted_by_current_user, :created_at, :updated_at

  belongs_to :challenge_participant, serializer: ChallengeParticipantSerializer


  # If you have any custom methods or transformation logic, you can define them here.
  # For example, if you need to format the timestamps or include transformed data:
  def file_attachment
    # Apply any transformation if necessary
    Rails.application.routes.url_helpers.rails_blob_url(object.file_attachment, host: 'localhost:4000')
  end

  def video_attachment
    # Apply any transformation if necessary
    Rails.application.routes.url_helpers.rails_blob_url(object.video_attachment, host: 'localhost:4000')
  end

  def evidence_attachment_urls
    return [] unless object.evidence_attachment.attached?

    object.evidence_attachment.map do |attachment|
      Rails.application.routes.url_helpers.rails_blob_url(attachment, host: 'localhost:4000')
    end
  end

  def challenge
    object.challenge_participant.challenge
  end

  def voted_by_current_user
    current_user = @instance_options[:current_user] # Access current_user here
    current_user.present? && object.votes.exists?(user: current_user)
  end
end