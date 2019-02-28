$(document).on 'turbolinks:load', () ->
  window.App = {}
  class App.Notification
    constructor: ->
      $('body').on 'click', '.dropdown-notify',  (e) ->
        $(this).parent().is '.open' && e.stopPropagation();

      @notifications = $('[data-behavior="notifications"]')

      if @notifications.length > 0
        @handleSuccess @notifications.data('notifications')
        $('.mark_as_read').on 'click', @marAllAsRead
        $('.read_all').on 'click', (e) ->
          window.location.href = $(this).prop 'href'
        @getNewNotifications()

    getNewNotifications: ->
      $.ajax(
        url: '/notifications.json'
        dataType: 'JSON'
        method: 'GET'
        success: @handleSuccess
      )

    marAllAsRead: (e) =>
      _handleAlertBox = @handleAlertBox
      $.ajax(
        url: '/notifications/mark_as_read'
        dataType: 'JSON'
        method: 'POST'
        success: (response) =>
          if response.success
            $('.list-group-item').each (i, e) ->
              $(e).removeClass 'unread'
            $('[data-behavior="unread-count"]').text(0)
          else
            _handleAlertBox response
      )
      e.preventDefault()

    handleSuccess: (data) =>
      if data.error
        @handleAlertBox data
        return

      items = $.map data, (notification) -> notification.template
      if data.length <= 0
        items = '<li class="list-group-item flat text-center text-warning">'\
        + I18n.t("not_have.notifications") + '</li>'

      unread_count = 0
      $.each data, (i, notification) ->
        if notification.unread
          unread_count += 1

      $('[data-behavior="unread-count"]').text(unread_count)
      $('[data-behavior="notification-items"]').html(items)

    handleAlertBox: (response) =>
      if response.error
        alert_html = '<div class="alert alert-danger alert-dismissible
          auto-remove-alert">
          <a href="#" class="close" data-dismiss="alert">&times;</a>
          ' + response.error + ' </div>'
        $('.devise-alert').html alert_html

  new App.Notification
