MessageLength: 12 * 4

$.fn.typeset: ->
  elem: $(this).find('div')
  
  text: elem.html()
  line_height: elem.html('A').height()
  elem.html(text)
  elem.css {'width': '0.5em'}
  words: elem.html().split(/\s+/).length

  console.log elem.height() + " / " + line_height + " = " + (elem.height() / line_height)

  width: 0.5
  limit: Math.min(words, 4)
  while elem.height() / line_height > limit
    console.log elem.height() + " / " + line_height + " = " + (elem.height() / line_height)
    elem.css {'width': (width: width + 0.5) + 'em'}


$.fn.bigarsemessage: (text) ->
  $(this).children('div').html(text)
  $(this).attr 'class', $('form:first select option:selected').attr('class')
  $(this).show()
  $(this).typeset()
  # $(this).css({'opacity': 1})

$ ->
  $('#bigarsemessage').hide().click -> $(this).hide()
  $('form li input[type=submit]').click -> false

  $('form li input[type=submit][name=Preview]').click ->
    $('#bigarsemessage').bigarsemessage($('textarea.message').val())

  if $('form:first select option:selected').length == 0
    $('form:first select option.basic').attr('selected', 'selected')

  $('textarea.message').keyup ->
    if $(this).val().length > MessageLength
      $(this).val($(this).val().substring(0,MessageLength))
