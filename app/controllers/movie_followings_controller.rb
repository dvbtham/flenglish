class MovieFollowingsController < ApplicationController
  before_action :result_of_create_or_update, only: :create

  def create
    if @result
      respond_to do |format|
        format.json {render json: {message: @message, next_action: @next_action}}
      end
    else
      respond_to do |format|
        format.json do
          render json: {error_messages: @following.errors.full_messages,
            has_errors: Settings.error_status.internal}
        end
      end
    end
  end

  private

  def result_of_create_or_update
    @following = MovieFollowing.find_by(user_id: following_params[:user_id],
      movie_id: following_params[:movie_id])
    if @following
      @result = @following.destroy
      @next_action = t(:follow)
      @message = t "movie_follow.remove"
    else
      @following = MovieFollowing.new
      @following.assign_attributes following_params
      @result = @following.save
      @next_action = t(:unfollow)
      @message = t "movie_follow.create"
    end
  end

  def following_params
    params.require(:follow).permit :user_id, :movie_id
  end
end
