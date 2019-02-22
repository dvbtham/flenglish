# Preview all emails at http://localhost:3000/rails/mailers/following_mailer
class FollowingMailerPreview < ActionMailer::Preview
  def to_users_following_movie
    user = User.first
    movie = Movie.first
    FollowingMailer.to_users_following_movie user, movie
  end
end
