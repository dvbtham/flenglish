class NotificationWorker
  include Sidekiq::Worker

  sidekiq_options queue: :notify

  def perform episode_id, user_id
    actor = User.find_by id: user_id
    episode = Episode.find_by id: episode_id
    return unless actor || episode || episode.movie
    Notification.transaction do
      episode.movie.followers.each do |user|
        if actor != user
          Notification.create recipient: user, actor: actor,
            action: I18n.t("notify.action.added"), notifiable: episode
        end
      end
    end
  end
end
