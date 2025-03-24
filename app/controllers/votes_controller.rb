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
    user = Profile.find(params[:profile_id]).user
    entry = Entry.find(params[:entry_id])
    creator_id =  Challenge.find(params[:challenge_id]).creator.id
    role = nil
    if params["profileId"].to_i == creator_id
      role = 'creator'
    end
    
    # Determine the vote's weight based on the user's role
    vote_weight = determine_vote_weight(role)

    vote = entry.votes.new(user: user, weight: vote_weight)
   
    if vote.save
      render json: { message: 'Vote successfully recorded' }, status: :created
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def determine_vote_weight(role)
    case role
    when 'creator', 'judge'
      5
    else
      1
    end
  end
end