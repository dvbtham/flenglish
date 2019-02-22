class MovieFollowingWorker
  include Sidekiq::Worker

  def perform user, movie
    puts "Name: #{user.full_name}, Movie: #{movie.title_en}"
  end
end
