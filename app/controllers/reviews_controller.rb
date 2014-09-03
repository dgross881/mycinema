class ReviewsController < ApplicationController
  
  def new 
    @reviews = @video.review.new 
  end 

  def create 
    @user = User.find_by(params[:id])
    @review = @user.review.new(review_params) 
    if @review.save
      redirect_to video_path, notice: "Your review has been posted" 
    else 
      flash[:error] = "Your post was not posted" 
     end 
    end       
  end

  private 
   def review_params 
    params.require(:review).permit(:content, :rating) 
   end 

