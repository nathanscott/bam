$ ->
  $('form li input[type=submit]').click ->
    $(this).parents('form:first').attr 'action', '/' + $(this).attr('value')
    $(this).parents('form:first').submit()
    false
