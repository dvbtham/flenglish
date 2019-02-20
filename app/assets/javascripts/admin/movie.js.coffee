$ ->
  $('form').on 'click', '.remove_episodes', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_episodes', (event) ->
    time = new Date().getTime()
    regexp = new RegExp(pattern: $(this).data('id'), flags: 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
