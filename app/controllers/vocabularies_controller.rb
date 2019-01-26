class VocabulariesController < ApplicationController
  include VocabulariesHelper

  before_action :logged_in_user, :load_movie, :load_episode,
    only: %i(create destroy)
  before_action :load_vocabulary, only: :destroy

  def create
    vocabulary = current_user.movie_vocabularies
      .new movie_id: params[:movie], dictionary_id: params[:vocabulary]
    flash.now[:success] = t :saved_vocabulary
    if vocabulary.save
      respond_to do |format|
        format.html do
          redirect_to watch_movie_path @movie,
            episode: @episode, tab: params[:tab]
        end
        format.js
      end
    else
      flash[:danger] = t "create_failed.vocabulary"
      redirect_to watch_movie_path @movie, episode: @episode
    end
  end

  def destroy
    @vocabulary.destroy
    flash.now[:success] = t "delete_success.vocabulary"
    respond_to do |format|
      format.html do
        redirect_to watch_movie_path @movie,
          episode: @episode, tab: params[:tab]
      end
      format.js
    end
  rescue StandardError
    flash[:danger] = t "delete_failed.vocabulary"
    redirect_to watch_movie_path @movie, episode: @episode
  end

  private

  def load_movie
    @movie = Movie.find_by id: params[:movie]
    return if @movie
    flash[:danger] = t "not_found.movie"
    redirect_to page_404_path
  end

  def load_episode
    @episode = @movie.episodes.find_by id: params[:episode]
    return if @episode
    flash[:danger] = t "not_found.episode"
    redirect_to page_404_path
  end

  def load_vocabulary
    @vocabulary = current_user.movie_vocabularies
      .find_by movie_id: params[:movie], dictionary_id: params[:vocabulary]
    return if @vocabulary
    flash[:danger] = t "not_found.vocabulary"
    redirect_to page_404_path
  end
end
