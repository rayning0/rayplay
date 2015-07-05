class VideosController < ApplicationController
  attr_accessor :video, :yt_vid, :user
  before_action :get_account, only: [:like, :dislike]
  before_action :get_user, only: [:index, :create, :destroy]

  def index
    puts "index: #{user.playlist.reverse}"
    @videos = user.videos.reverse
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    begin
      if video.save
        flash[:success] = 'Video added!'
        user.playlist << video.id
        puts "new playlist: #{user.playlist}"
        user.videos << video
        user.save
        binding.pry
      else
        render :new
      end
    # video already exists in DB
    rescue ActiveRecord::RecordNotUnique
      video = Video.find_by(uid: @video.uid)
      vid = video.id
      index = user.playlist.index(vid)

      if user.videos.map(&:id).include?(vid)
        # move id of duplicate video to end of playlist
        user.playlist << user.playlist.delete_at(index)
        user.videos << user.videos.delete(vid)
      else
        # where user's logged in but video not in user's playlist
        user.playlist << vid
        user.videos << video
      end
      puts "after duplicate: #{user.playlist}"
      user.save
    end
    redirect_to root_url
  end

  def destroy
    @video = Video.find(params[:id])
    user.playlist_will_change! # need it so Rails remembers deletion
    user.playlist.delete(video.id)
    user.videos.delete(video.id)
    user.save
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