class FollowingMailer < ApplicationMailer
  default from: Settings.no_reply_mail

  def to_users_following_movie user, movie
    @user = user
    @movie = movie
    mail to: user.email, subject: t("mailer.has_new_episode_title")
  end
end
