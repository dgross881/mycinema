class Admin::VideosController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def new 
    @video = Video.new 
  end 

  def create
    @video = Video.create(video_params)
    if @video.save
      flash[:success] = "#{@video.title} has been added" 
      redirect_to new_admin_video_path 
    else 
      flash[:error] = "You can not add this video please check the errors"
      render :new
    end 
  end 
  
  private 
  def require_admin 
    if !current_user.admin? 
      flash[:error] = "You are not authorized to visit thie page" 
      redirect_to home_path 
    end 
  end 

  def video_params 
    params.require(:video).permit(:title, :description, :category_id, :small_cover, :large_cover, :video_url)
  end 
end
