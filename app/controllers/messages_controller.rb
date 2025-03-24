class MessagesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @chats = Chat.find(params[:chat_id])
    @messages = @chat.messages
    render json: @messages
  end

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.build(message_params)
    @message.user = current_user
    if @message.save
      ChatChannel.broadcast_to(@chat, @message)
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def message_params
    params.require(:message).permit(:context)
  end
end