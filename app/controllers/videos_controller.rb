class VideosController < ApplicationController
  attr_accessor :video, :yt_vid, :user
  before_action :get_account, only: [:like, :dislike]
  before_action :get_user, only: [:index, :create, :destroy]

  def index
    puts "playlist video ids: #{user.playlist.map(&:video_id)}"
    puts "video ids: #{user.videos.map(&:id)}"
    @videos = user.videos
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    begin
      if video.save
        flash[:success] = 'Video added!'
        user.videos << video
        puts "new playlist position: #{user.playlist.find_by(video_id: video.id).position}"
        user.save
      else
        render :new
      end
    # video already exists in DB
    rescue ActiveRecord::RecordNotUnique
      video = Video.find_by(uid: @video.uid)
      vid = video.id

      if user.videos.map(&:id).include?(vid)
        # move duplicate video to front of playlist
        # and reorder all other video positions
        user.playlist.find_by(video_id: vid).move_to_bottom
        user.reload
      else
        # where user's logged in but video not in user's playlist
        user.videos << video
      end
      user.save
      puts "after duplicate videos: #{user.videos.map(&:id)}"
    end
    redirect_to root_url
  end

  def destroy
    @video = Video.find(params[:id])
    user.videos.delete(video.id)
    user.save
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

  def get_user
    @user = current_user ? current_user : User.find_by(name: 'Generic')
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