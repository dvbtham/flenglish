class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel#{params[:user_id]}"
  end

  def unsubscribed; end
end
