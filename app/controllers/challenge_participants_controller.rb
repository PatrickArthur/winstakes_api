class ChallengeParticipantsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user, only: [:join]
	before_action :set_challenge, only: [:index, :unjoin, :destroy]


	def index
		render json: @challenge.challenge_participants, each_serializer: ChallengeParticipantSerializer
	end

	def join
	    challenge = Challenge.find(params[:challenge_id])
	    wallet = current_user.wallet || current_user.create_wallet
	    fee = challenge.entry_fee || 0
	    
	    if wallet.balance < fee
	      render json: { error: "Not enough tokens" }, status: :payment_required and return
	    end

	    ActiveRecord::Base.transaction do
	      wallet.adjust!(-fee)

	      participant = challenge.challenge_participants.create!(
	        user: @user
	      )

	      render json: participant, status: :created
	    end
	end

  	def unjoin
	    participant = ChallengeParticipant.find(params[:participant_id])
	    entry = participant.entries.find_by(challenge_participant_id: participant.id) unless participant.entries.empty? 

	    if entry.present?
	      render json: { error: "Cannot leave after submitting an entry" }, status: :forbidden
	    else
	      participant.destroy
	      render json: { message: "You have left the challenge." }, status: :ok
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
