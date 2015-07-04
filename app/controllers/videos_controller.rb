class VideosController < ApplicationController
  attr_accessor :video, :yt_vid
  before_action :get_account, only: [:like, :dislike]

  def index
    @videos = Video.order('created_at DESC')
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if video.save
      flash[:success] = 'Video added!'
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    @video = Video.find(params[:id])
    video.destroy
    flash[:success] = "Video was deleted."
    redirect_to root_url
  end

  def like
    yt_vid.like
    video.update(likes: yt_vid.like_count, dislikes: yt_vid.dislike_count)
    render json: { likes: video.likes, dislikes: video.dislikes, uid: video.uid }
  end

  def dislike
    yt_vid.dislike
    video.update(likes: yt_vid.like_count, dislikes: yt_vid.dislike_count)
    render json: { likes: video.likes, dislikes: video.dislikes, uid: video.uid }
  end

  private

  def video_params
    params.require(:video).permit(:link, :likes, :dislikes)
  end

  def get_account
    @video = Video.find(params[:id])
    if current_user && request.xhr?
      account = Yt::Account.new(access_token: current_user.token)
      @yt_vid = Yt::Video.new(id: @video.uid, auth: account)
    else
      flash[:danger] = "You must be logged in to like/dislike videos or your token has expired. Relog in."
      flash.keep
      render json: { error: flash }
    end
  end
end