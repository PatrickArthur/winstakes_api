class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:followers, :following]
  
  def create
    user = Profile.find(params[:follower_id])&.user
    if user
      current_user.follow(user)
      render json: { message: 'Followed #{user.email} succesfully' }, status: :created
    else
      render json: { error: 'User not found.' }, status: :not_found
    end
  end

  def destroy
    relationship = Relationship.where(follower_id: current_user.profile.id, followed_id: params[:id])
    if relationship
      user = relationship.last.followed
      current_user.unfollow(user)
      render json: { message: 'Unfollowed #{user.email} succesfully.' }, status: :ok
    else
      render json: { error: 'user not found.' }, status: :not_found
    end
  end

  def followers
    @followers = @user.followers.map(&:profile)  # Retrieve profiles of followers
    follow_json(@followers)
  end

  def following
    @following = @user.following.map(&:profile)  # Retrieve profiles of followed users
    follow_json(@following)
  end

  private

  def find_user
    profile = Profile.find(params[:id])
    if profile
      @user = profile.user
    else
      render json: { error: "User not found"}, status: :not_found
    end
  end

  def follow_json(profiles)
    profiles_json = profiles.present? ? profiles.map do |profile|
      serialized_profile = ActiveModelSerializers::SerializableResource.new(profile, serializer: ProfileSerializer).as_json
      if serialized_profile[:profile]
        serialized_profile[:profile][:is_following] = current_user.following?(profile.user)
        serialized_profile[:profile][:is_follower] = current_user.follower?(profile.user)
        serialized_profile[:profile]
      else
        serialized_profile.merge(is_following: current_user.following?(profile.user), is_follower: current_user.follower?(profile.user))
      end.compact
    end.compact : []

    render json: { profiles: profiles_json }, each_serializer: ProfileSerializer
  end
end