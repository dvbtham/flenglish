ready = ->
  $('.favorite').on 'click', (e) ->
    data = {
      favorite: {
        user_id: $(this).data('user'),
        movie_id: $(this).data('movie')
      }
    }
    link = $(this)
    $.ajax '/favorites',
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

$(document).on('turbolinks:load', ready)
