ready = ->
  $('.follow').on 'click', (e) ->
    data = {
      follow: {
        user_id: $(this).data('user'),
        movie_id: $(this).data('movie')
      }
    }
    link = $(this)
    $.ajax '/movie_followings',
      type: 'POST'
      dataType: 'json'
      data: data
      error: (jqXHR, textStatus, errorThrown) ->
        $('.follow-alert').html(jqXHR.responseText).removeClass('hidden')
          .addClass('alert-success')
      success: (data, textStatus, jqXHR) ->
        $('.follow-alert').html(data.message).removeClass('hidden')
          .addClass('alert-success')
        link.text data.next_action
    e.preventDefault()
$(document).ready(ready)
$(document).on('turbolinks:load', ready)
