class Admin::EpisodesController < Admin::BaseController
  before_action :load_episode, only: %i(destroy show)
  before_action :load_movie, only: :create

  def create
    @episode = Episode.find_or_create_by id: episode_params[:id]
    @episode.assign_attributes episode_params
    if @episode.save
      MovieFollowingWorker.perform_async @movie.id
      NotificationWorker.perform_async @episode.id, current_user.id,
        Settings.notifications.limit
      respond_to do |format|
        format.json do
          render json: {record: @episode, message: t(:save_success)}
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {error_messages: @episode.errors.full_messages,
            has_errors: Settings.error_status.internal}
        end
      end
    end
  end

  def show
    render json: @episode
  end

  def destroy
    Episode.transaction do
      @episode.destroy!
      Notification.get_notifiable(@episode.id).each &:destroy!
      respond_to do |format|
        format.json{render json: {message: t("delete_success.episode")}}
      end
    end
  rescue ActiveRecord::RecordNotDestroyed
    respond_to do |format|
      format.json do
        render json: {error_messages: t("delete_failed.episode"),
          has_errors: Settings.error_status.internal}
      end
    end
  end

  private

  def load_episode
    @episode = Episode.find_by id: params[:id]
    return if @episode
    flash[:danger] = t "not_found.episode"
    redirect_to page_404_path
  end

  def episode_params
    params.require("episode").permit :id, :name, :video_url, :movie_id
  end

  def load_movie
    @movie = Movie.find_by id: episode_params[:movie_id]
    return if @movie
    flash[:danger] = t "not_found.movie"
    redirect_to page_404_path
  end
end
