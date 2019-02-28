class NotificationWorker
  include Sidekiq::Worker

  sidekiq_options queue: :notify

  def perform episode_id, user_id, limit
    notifications = {}
    actor = User.find_by id: user_id
    episode = Episode.find_by id: episode_id
    return unless actor || episode || episode.movie
    Notification.transaction do
      episode.movie.followers.each do |user|
        if actor != user
          Notification.create! recipient: user, actor: actor,
            action: I18n.t("notify.action.added"), notifiable: episode
          notifications[user.id] = render_notifications_of user, limit
        end
      end
    end
    ActionCable.server.broadcast "notification_channel",
      notifications: notifications
  rescue ActiveRecord::RecordNotSaved
    ActionCable.server.broadcast "notification_channel",
      error: I18n.t("create_failed.notification")
  end

  private

  def render_notifications_of user, limit
    user.notifications
      .recent(limit).map do |notification|
      template = ApplicationController
        .renderer.render(partial: "notifications/" +
        "#{notification.notifiable_type.underscore.pluralize}/" +
        "#{notification.action}",
        locals: {notification: notification}, formats: [:html])
      # Return a hash
      {
        id: notification.id,
        unread: !notification.read_at?,
        template: template
      }
    end
  end
end
