class MovieFollowingWorker
  include Sidekiq::Worker

  sidekiq_options queue: :mailers

  def perform movie_id
    movie = Movie.find_by id: movie_id
    return unless movie
    movie.followers.each do |user|
      movie.mail_to_user_following user
    end
  end
end
