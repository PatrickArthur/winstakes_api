class NotificationsController < ApplicationController
	
	before_action :authenticate_user!
	
	def index
		user = User.find_by_id(current_user.id)
		render json: user.notifications, each_serializer: NotificationSerializer, status: :ok
	end

	def show
	end

	def mark_as_read
		notification = current_user.notifications.find(params[:id])
	    
	    if notification.update(read: true)
	      render json: { status: 'success', message: 'Notification marked as read' }, status: :ok
	    else
	      render json: { status: 'error', message: 'Failed to update notification' }, status: :unprocessable_entity
	    end
	end
end
