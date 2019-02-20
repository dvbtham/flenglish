class CommentsController < ApplicationController
  before_action :load_movie, :load_comments, only: %i(create destroy)
  before_action :load_comment, only: :destroy

  load_and_authorize_resource

  def create
    @comment = Comment.new comment_params
    if @comment.save
      flash.now[:success] = t "create_success.comment"
      comment_success_respond
    else
      flash.now[:danger] = populate_error_message @comment
      respond_to do |format|
        format.js{render file: Settings.shared.file.js.comment}
      end
    end
  end

  def destroy
    if @comment.destroy
      flash.now[:success] = t "delete_success.comment"
      comment_success_respond
    else
      flash[:danger] = t "delete_failed.comment"
      redirect_to page_500_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit :user_id, :movie_id, :content
  end

  def load_movie
    @movie = Movie.find_by id: get_movie_id
    return if @movie
    flash[:danger] = t "not_found.movie"
    redirect_to page_404_path
  end

  def get_movie_id
    params[:comment].present? ? params[:comment][:movie_id] : params[:movie_id]
  end

  def load_comment
    @comment = Comment.find_by id: params[:id]
    return if @comment
    flash[:danger] = t "not_found.comment"
    redirect_to page_404_path
  end

  def load_comments
    @comments = @movie.comments_with_pagination params[:page]
  end

  def populate_error_message comment
    return t "create_failed.comment" unless comment.errors.any?
    comment.errors.messages.values.flatten.map(&:to_s).join "<br/>"
  end

  def comment_success_respond
    respond_to do |format|
      format.js{render file: Settings.shared.file.js.comment}
    end
  end
end
