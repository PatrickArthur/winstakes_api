class ChallengesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    challenges = if params[:user_challenges] == "true"
      Challenge.participated_in(current_user).not_created_by(current_user)
    elsif params[:created_challenges] == "true"
      Challenge.created_by(current_user)
    else
      Challenge.not_participated_by(current_user).not_created_by(current_user)
  end
    render json: challenges, each_serializer: ChallengeSerializer
  end

  def show
    challenge = Challenge.find(params[:id])
    render json: challenge, serializer: ChallengeSerializer, current_user: current_user
  end

  def create
    @challenge = current_user.created_challenges.new(challenge_params)

    ActiveRecord::Base.transaction do
      if @challenge.save
        handle_judges(@challenge)
        handle_criteria(@challenge)

        render json: @challenge, serializer: ChallengeSerializer, status: :created
      else
        render json: @challenge.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::StatementInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    challenge = find_challenge(params[:id])
    return if challenge.nil?

    ActiveRecord::Base.transaction do
      if challenge.update(challenge_params)
        handle_judges(challenge)
        handle_criteria(challenge)

        render json: challenge, serializer: ChallengeSerializer, status: :ok
      else
        render json: challenge.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::StatementInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    challenge = Challenge.find(params[:id])
    if challenge.destroy
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def find_challenge(challenge_id)
    challenge = current_user.created_challenges.find_by(id: challenge_id)
    unless challenge
      render json: { error: "Challenge not found" }, status: :not_found
      return nil
    end
    challenge
  end

  def handle_judges(challenge)
    judge_ids = params[:judges]&.map(&:to_i) || []
    challenge.manage_judges(judge_ids, challenge.judging_method)
  end

  def handle_criteria(challenge)
    Criterion.update_criteria_for_challenge(challenge, criteria_params)
  end

  def criteria_params
    # Allow permitting id and name for criteria; id should ideally not be needed for new records.
    params.require(:criteria).permit!.to_h
  end

  def challenge_params
    params.require(:challenge).permit(:title, :description, :criteria_for_winning, :judging_method, :prize_type, :token_prize_percentage, :finals_judging, :fixed_token_prize, :entry_fee, :product_id, :video, :start_date, :end_date)
  end
end