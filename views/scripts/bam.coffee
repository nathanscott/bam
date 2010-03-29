$ ->
  $('form li input[type=submit]').click ->
    $('form:first').attr 'action', '/' + $(this).attr('value')
    $('form:first').submit()
    false
