class CommentsController < ApplicationController
	before_action :authenticate_user!

	def index
		@wonk = Wonk.find(params[:wonk_id])
		@comments = @wonk.comments
		render json: @comments
	end

	def show
		@comment = Comment.includes(replies: :profile).find(params[:id])
	    if @comment.present?
	      # Logic for when the current user is part of the chat
	      render json: @comment, serializer: CommentSerializer, status: :ok
	    else
	      # Logic for when the current user is not part of the chat
	      render json: { error: "You do not have access to this chat" }, status: :forbidden
	    end
	end

	def create
		comment = Comment.new(comment_params)
		comment.user = current_user

		if params[:parent_comment_id].present?
    		comment.parent_comment_id = params[:parent_comment_id]
    	end
    	
		if comment.save
			render json: comment, serializer: CommentSerializer, status: :ok
		else
			render json: comment.errors, status: :unprocessable_entity
		end
	end

	def destroy
	    @comment = Comment.find(params[:id])
	    if @comment.destroy
	      ActionCable.server.broadcast 'comments_channel', { id: params[:id], action: 'delete' }
	      head :no_content
	    else
	      head :unprocessable_entity
	    end
  	end

	private

	def comment_params
		params.require(:comment).permit(:content, :profile_id, :wonk_id, :parent_comment_id)
	end
end
