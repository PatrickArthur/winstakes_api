class FavoriteJudgesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_judge_profile, only: [:create, :destroy]

  def index
    favorite_judges = current_user.favorite_judges
    render json: favorite_judges, each_serializer: FavoriteJudgeSerializer
  end

  def create
    favorite = current_user.favorite_judges.new(profile: @judge_profile)
    if favorite.save
      render json: { message: 'Judge added to favorites successfully.' }, status: :created
    else
      render json: { errors: favorite.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    favorite = current_user.favorite_judges.find_by(profile: @judge_profile)
    if favorite
      favorite.destroy
      render json: { message: 'Judge removed from favorites successfully.' }, status: :ok
    else
      render json: { error: 'Favorite not found.' }, status: :not_found
    end
  end


  private

  def set_judge_profile
    @judge_profile = Profile.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Profile not found or not a judge.' }, status: :not_found
  end
end