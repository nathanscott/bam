MessageLength: 12 * 4

$.fn.typeset: ->
  elem: $(this).find('div')
  lines: elem.html().split(/\s+/)
  line_lengths: i.length for i in lines
  longest_line: Math.max line_lengths...
  console.log longest_line
  elem.css {width: '5em'}
  scale: 21

$.fn.bigarsemessage: (text) ->
  $(this).children('div').html(text)
  $(this).attr 'class', $('form:first select option:selected').attr('class')
  $(this).typeset()
  console.log text
  $(this).show()

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
