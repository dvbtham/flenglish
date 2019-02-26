class NotificationsController < ApplicationController
  include NotificationsHelper

  before_action :authenticate_user!
  before_action :load_notifications, only: %i(index mark_as_read)

  def index
    respond_to do |format|
      format.html
      format.json{render file: Settings.jbuilder.notifications}
    end
  end

  def mark_as_read
    Notification.transaction do
      @notifications.update_all read_at: Time.zone.now
    end
    render json: {success: true}
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotSaved
    render json: {success: false, error: t(:mark_as_read_fail)}
  end

  private

  def load_notifications
    @notifications = current_user.notifications
      .recent Settings.notifications.limit
  end
end
