class VotesController < ApplicationController
  before_action :authenticate_user!

  def check
    user_id = Profile.find(params[:profile_id]).user.id
    entry_id = params[:entry_id]

    # Check if the user has already voted for the specified entry
    voted = Vote.exists?(user_id: user_id, entry_id: entry_id)

    # Return a JSON object as a response
    render json: { user_id: user_id, entry_id: entry_id, voted: voted }
  end

  def create
    challenge = Challenge.find(params[:challenge_id])
    entry = Entry.find(params[:entry_id])

    unless challenge.voting_open?
      return render json: { error: "Voting is not open at this time" }, status: :forbidden
    end

    unless can_vote?(challenge, current_user)
      return render json: { error: "You are not allowed to vote in this challenge" }, status: :forbidden
    end

    if Vote.exists?(user: current_user, challenge: challenge)
      return render json: { error: "You have already voted in this challenge" }, status: :unprocessable_entity
    end

    vote = Vote.new(user: current_user, challenge: challenge, entry: entry)

    if vote.save
      render json: vote, status: :created
    else
      render json: vote.errors, status: :unprocessable_entity
    end
  end

  private

  def can_vote?(challenge, user)
    case challenge.judging_method
    when "publicVote"
      true
    when "participantsOnly"
      challenge.participants.exists?(user_id: user.id)
    when "hybridVote"
      is_participant = challenge.challenge_participants.exists?(user_id: user.id)
      is_follower = challenge.creator.followers.exists?(id: user.id)
      is_participant || is_follower
    else
      false
    end
  end
end