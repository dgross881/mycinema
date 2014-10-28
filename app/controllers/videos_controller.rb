class VideosController < ApplicationController 
  before_filter :require_user 

  def index
    @categories = Category.all 
  end 

  def show 
    @video = Video.find(params[:id])
    @reviews = @video.reviews 
  end 

  def search 
    @search = Video.search do
      fulltext params[:search]
    end 
    @results = @search.results
  end 
end 
