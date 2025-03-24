class ChatsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @chats = Chat.where(user1_id: current_user.id).or(Chat.where(user2_id: current_user.id))
    render json: @chats
  end

  def create
    user1_id = current_user.id
    user2_id = Profile.find(params[:user2_id]).user.id
    if user2_id.present?
      chat = Chat.find_by(user1_id: user1_id, user2_id: user2_id) ||
      Chat.find_by(user1_id: user2_id, user2_id: user1_id)
      if chat.nil?
        chat = Chat.create(user1_id: user1_id, user2_id: user2_id)
      end

      render json: chat, serializer: ChatSerializer, status: :created
    else
      render json: { error: "You do not have access to this chat" }, status: :forbidden
    end
  end

  def show
    @chat = Chat.find(params[:id])
    if @chat.belongs_to_user?(current_user)
      # Logic for when the current user is part of the chat
      render json: @chat, serializer: ChatSerializer, status: :ok
    else
      # Logic for when the current user is not part of the chat
      render json: { error: "You do not have access to this chat" }, status: :forbidden
    end
  end
end