class FriendshipsController < ApplicationController
  before_filter :require_user 

  def create
    leader = User.find(params[:leader_id])
    @friendship = Friendship.create(leader_id: params[:leader_id], follower: current_user) if current_user.can_follow?(leader)
    redirect_to friends_path
  end 

  def index
   @friendships = current_user.following_friends
  end 

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy if @friendship.follower == current_user  
    redirect_to friends_path 
  end 
end
