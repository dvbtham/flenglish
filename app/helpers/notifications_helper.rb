module NotificationsHelper
  def build_notifiable_type notification
    t Settings.notify_type_section + notification.notifiable.class.to_s
      .underscore.humanize.downcase,
      movie_name: notification.notifiable.movie.title_en
  end
end
