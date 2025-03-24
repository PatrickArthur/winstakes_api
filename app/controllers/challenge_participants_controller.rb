class ChallengeParticipantsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user, only: [:join]
	before_action :set_challenge, only: [:index, :unjoin, :destroy]


	def index
		render json: @challenge.challenge_participants, each_serializer: ChallengeParticipantSerializer
	end

	def join
		challenge = Challenge.find(params[:challenge_id])
		if @user.challenges.exists?(challenge.id)
			render json: { message: "Already joined this challenge" }, status: :unprocessable_entity
		else
			@user.challenges << challenge
			render json: { message: "Challenge joined successfully" }, status: :ok
		end
	end

	def unjoin
	  participant = @challenge.challenge_participants.find_by(user: current_user)

	  if participant&.destroy
	    render json: { message: "Unjoined successfully." }, status: :ok
	  else
	    render json: { error: "Unable to unjoin." }, status: :unprocessable_entity
	  end
	end

  	def destroy
  		@challenge_participant = ChallengeParticipant.find(params[:id])
  		@challenge_participant.entries.destroy_all
  		if @challenge_participant.destroy
	      head :no_content
	    else
	      head :unprocessable_entity
	    end
  	end

	private

	def set_challenge
		@challenge = Challenge.find(params[:challenge_id])
	end

	def set_user
		@user = User.find(params[:profile_id])
	end
end
