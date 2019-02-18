class VocabulariesController < ApplicationController
  include VocabulariesHelper

  before_action :authenticate_user!, :load_movie, :load_episode,
    only: %i(create destroy)
  before_action :load_vocabulary, only: :destroy

  def create
    vocabulary = current_user.movie_vocabularies.new(movie_id: params[:movie],
     dictionary_id: params[:vocabulary])
    if vocabulary.save
      flash.now[:success] = t :saved_vocabulary
      respond_with_tab @movie, @episode
    else
      flash[:danger] = t "create_failed.vocabulary"
      redirect_to watch_movie_path @movie, episode: @episode
    end
  end

  def destroy
    @vocabulary.destroy
    flash.now[:success] = t "delete_success.vocabulary"
    respond_with_tab @movie, @episode
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
    @vocabulary = current_user.find_vocabulary params[:movie],
      params[:vocabulary]
    return if @vocabulary
    flash[:danger] = t "not_found.vocabulary"
    redirect_to page_404_path
  end

  def respond_with_tab movie, episode
    respond_to do |format|
      format.html do
        redirect_to watch_movie_path movie, episode: episode,
          tab: params[:tab]
      end
      format.js
    end
  end
end
