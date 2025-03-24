class ProfilesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :update, :destroy]


  # GET /profiles
  def index
    @profiles = Profile.all
    
    render json: @profiles
  end

  # GET /profiles/1
  def show
    render json: @profile
  end

  # POST /profiles
  def create
    @profile = current_user.build_profile(profile_params)

    if @profile.save
      
      render json: @profile, serializer: ProfileSerializer, status: :created
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profiles/1
  def update
    if @profile.update(profile_params)
      render json: @profile
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/1
  def destroy
    @profile.destroy
    head :no_content
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:photo, :first_name, :last_name, :user_name, :date_of_birth, :city, :state, :zip_code, :is_judge, :category, :bio, :interests => [])
  end
end
