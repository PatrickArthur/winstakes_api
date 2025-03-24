class WonksController < ApplicationController

  before_action :authenticate_user!

  def index
    if params[:post_type] == "challenge"
      wonks = Wonk.where(challenge_id: params[:profile_id], wonk_type: "challenge").order(created_at: :desc).page(params[:page]).per(1) 
    else
      wonks = Wonk.where(profile_id: params[:profile_id]).order(created_at: :desc).page(params[:page]).per(1) 
    end
    render json: wonks, each_serializer: WonkSerializer, status: :ok
  end

  def show
    @wonk = Wonk.find(params[:id])
    if @wonk.present?
      # Logic for when the current user is part of the chat
      render json: @wonk, serializer: WonkSerializer, status: :ok
    else
      # Logic for when the current user is not part of the chat
      render json: { error: "You do not have access to this chat" }, status: :forbidden
    end
  end

  def create
    wonk = current_user.wonks.build(wonk_params)

    if params[:challenge_id].present?
      wonk.challenge_id = params[:challenge_id]
      wonk.wonk_type = "challenge"
    end

    wonk.user_id = current_user.id
    wonk.profile_id = current_user.profile.id

    if wonk.save
      WonkJob.perform_later(wonk)
      render json: wonk, status: :created
    else
      render json: { errors: wonk.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @wonk = Wonk.find(params[:id])
    if @wonk.destroy
      ActionCable.server.broadcast 'wonk_channel', { id: params[:id], action: 'delete' }
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def wonk_params
    params.require(:wonk).permit(:content)
  end
end