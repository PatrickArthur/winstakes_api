class LikesController < ApplicationController
	before_action :set_likeable, only: [:create, :destroy]

	def create
	   profile = current_user.profile
	   like = @likeable.likes.new(user: current_user, profile_id: profile.id)

       if like.save
         render json: like, status: :created
       else
         render json: like.errors, status: :unprocessable_entity
       end
     end

     def destroy
       like = @likeable.likes.find_by(user: current_user)

       if like
         like.destroy
         render json: { message: 'Unliked successfully' }, status: :ok
       else
         render json: { message: 'Like not found' }, status: :not_found
       end
     end

     private

     def set_likeable
	  if params["comment_id"]
	    @likeable = Comment.find(params["comment_id"])
	  elsif params["wonk_id"]
	    @likeable = Wonk.find(params["wonk_id"])
	  elsif params["challenge_id"]
	    @likeable = Challenge.find(params["challenge_id"])
	  else
	    raise "No valid likeable resource type found."
	  end
	end
end