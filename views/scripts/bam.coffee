MessageLength: 12 * 4

$ ->
  $('form li input[type=submit]').click ->
    $('form:first').attr 'action', '/' + $(this).attr('value')
    $('form:first').submit()
    false

  if $('form:first select option:selected').length == 0
    $('form:first select option.basic').attr('selected', 'selected')

  $('textarea.message').keyup ->
    if $(this).val().length > MessageLength
      $(this).val($(this).val().substring(0,MessageLength))
