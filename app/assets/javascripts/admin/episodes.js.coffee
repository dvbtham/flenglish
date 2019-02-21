$ ->
  $('.add_episodes').on 'click', (e) ->
    data = {
      episode: {
        id: $('#episode_id').val(),
        movie_id: $('#episode_movie_id').val(),
        name: $('#episode_name').val(),
        video_url: $('#episode_video').val()
      }
    }
    $.ajax '/admin/episodes',
      type: 'POST'
      dataType: 'json'
      data: data
      error: (jqXHR, statusText, message) ->
        $('.episode-alert').html(message).removeClass('hidden')
          .addClass('alert-danger')
      success: (data, textStatus, jqXHR) ->
        if data.has_errors
          errors_html = ''
          $.each data.error_messages, (index, data) ->
            errors_html += '<li>' + data + '</li>'
          $('.episode-alert').html('<ul>' + errors_html + '</ul>')
            .removeClass('hidden').addClass('alert-danger')
        else
          $('.episode-alert').html(data.message)
            .removeClass('hidden alert-danger').addClass('alert-success')
    e.preventDefault()

  $('.remove-episodes').on 'click', (e) ->
    episode_id = $(e.target).data('id')
    $.ajax '/admin/episodes/' + episode_id,
      type: 'DELETE'
      dataType: 'json'
      error: (jqXHR, statusText, message) ->
        $('.episode-alert').html(message).removeClass('hidden')
          .addClass('alert-danger')
      success: (data, textStatus, jqXHR) ->
        if data.has_errors
          $('.episode-alert').html(data.error_messages)
            .removeClass('hidden').addClass('alert-danger')
        else
          $('.episode-alert').html(data.message)
            .removeClass('hidden alert-danger').addClass('alert-success')
          $('a[data-id="' + episode_id + '"]').fadeOut()
          $(e.target).fadeOut()
    e.preventDefault()

  $('.movie-episode').on 'click', (e) ->
    episode_id = $(e.target).data('id')
    $.ajax '/admin/episodes/' + episode_id,
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, statusText, message) ->
        $('.episode-alert').html(message).removeClass('hidden')
          .addClass('alert-danger')
      success: (data, textStatus, jqXHR) ->
        $('#episode_id').val(episode_id)
        $('#episode_name').val(data.name)
        $('#episode_video').val(data.video_url)

    e.preventDefault()
