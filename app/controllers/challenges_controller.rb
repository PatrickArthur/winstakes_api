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
    render json: challenge, serializer: ChallengeSerializer
  end

  def create
    challenge = current_user.created_challenges.new(challenge_params)

    criteria_params.each do |_, criterion_attr|
      challenge.criteria.build(criterion_attr)
    end
    
    if challenge.save
      if params[:judges].present?
        judges = User.find(params[:judges])
        if challenge.judges.include?(judges)
          render json: { error: 'User is already a judge for this challenge' }, status: :unprocessable_entity
        else
          challenge.judges << judges
          render json: challenge, serializer: ChallengeSerializer, status: :created
        end
      else
        render json: challenge, serializer: ChallengeSerializer, status: :created
      end
    else
      render json: challenge.errors, status: :unprocessable_entity
    end
  end

  def update
    challenge = current_user.created_challenges.find_by(id: params[:id])
    valid_judging_methods = ['publicVote', 'automatedFirstComplete']

    if challenge.nil?
      render json: { error: "Challenge not found" }, status: :not_found
      return
    end

    ActiveRecord::Base.transaction do
      if challenge.update(challenge_params)
        judge_ids = params[:judges]&.map(&:to_i) || []
        challenge.manage_judges(judge_ids, challenge.judging_method)

        if valid_judging_methods.include?(challenge.judging_method)
          challenge.criteria.destroy_all
        else
          Criterion.update_criteria_for_challenge(challenge, criteria_params)
        end

        render json: challenge, serializer: ChallengeSerializer, status: :ok
      else
        raise ActiveRecord::Rollback
      end
    rescue ActiveRecord::RecordInvalid
      render json: challenge.errors, status: :unprocessable_entity
    end
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

  def criteria_params
    # Allow permitting id and name for criteria; id should ideally not be needed for new records.
    params.require(:criteria).permit!.to_h
  end

  def challenge_params
    params.require(:challenge).permit(:title, :description, :criteria_for_winning, :judging_method, :prize_type, :token_prize_percentage, :fixed_token_prize, :product_id, :video, :start_date, :end_date)
  end
end