App.notifications = App.cable.subscriptions.create {
  channel: 'NotificationsChannel',
  user_id: parseInt($('#user_id').val())},
  received: (data) ->
    notification = new App.Notification
    if data.error
      notification.handleAlertBox data
    else
      notifications = data.notifications[parseInt($('#user_id').val())]
      notification.handleSuccess notifications
