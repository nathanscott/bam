$ ->
  $('form li input[type=submit]').click ->
    $('form:first').attr 'action', '/' + $(this).attr('value')
    $('form:first').submit()
    false

  $('form:first select option.basic').attr('selected', 'selected')

  # TODO textarea.message needs a character limit
  # TODO submit buttons need form action changers onclick