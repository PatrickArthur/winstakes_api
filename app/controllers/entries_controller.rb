class EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge_participant, only: [:index, :create, :show, :update, :destroy], if: -> { params[:challenge_participant_id].present? }
  before_action :set_entry, only: [:update, :destroy, :show]

  # List all entries for a specific challenge participant

  def index
    if params[:id]
      # Find the challenge and ensure the user is authorized to view it
      @challenge = Challenge.find(params[:id])

      # Assuming you have a method to verify user permissions (e.g., with Pundit)
      if current_user.can_view_challenge?(@challenge)
        # Fetch all entries for this challenge's associated participants
        @entries = Entry.joins(:challenge_participant)
                        .where(challenge_participants: { challenge_id: @challenge.id })
                        
        render json: @entries, each_serializer: EntrySerializer
      else
        render json: { error: 'Not authorized to view entries for this challenge' }, status: :unauthorized
      end
    else
      # Falling back to existing logic for challenge participants
      if @challenge_participant.user == current_user
        @entries = @challenge_participant.entries
        render json: @entries, each_serializer: EntrySerializer
      else
        render json: { error: "Not authorized" }, status: :unauthorized
      end
    end
  end

  def show
    render json: @entry, serializer: EntrySerializer
  end

  # Update an entry
  def update
    if @entry.update(entry_params)
      EntriesChannel.broadcast_to(@challenge_participant, type: "update", entry: ActiveModelSerializers::SerializableResource.new(@entry, serializer: EntrySerializer).as_json)
      render json: @entry, serializer: EntrySerializer
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # Delete an entry
  def destroy
    @entry.destroy
    EntriesChannel.broadcast_to(@challenge_participant, type: "destroy", entry_id: @entry.id)
    head :no_content
  end

  # Create a new entry
  def create
    @entry = @challenge_participant.entries.build(entry_params)

    if @entry.save
      EntriesChannel.broadcast_to(@challenge_participant, type: "create", entry: ActiveModelSerializers::SerializableResource.new(@entry, serializer: EntrySerializer).as_json)
      render json: @entry, serializer: EntrySerializer, status: :created
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  private

  def set_challenge_participant
    @challenge_participant = ChallengeParticipant.find(params[:challenge_participant_id])
  end

  def set_entry
    @entry = @challenge_participant.entries.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:title, :description, :file_attachment, :video_attachment, evidence_attachment: [])
  end
end