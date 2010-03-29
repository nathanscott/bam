MessageLength: 12 * 4

$.fn.typeset: ->
  elem: $(this).find('div')

  words: elem.html().split(/\s+/).length

  text: elem.html()
  line_height: elem.html('A').height()
  elem.html(text)

  elem.css {'width': '0.5em'}

  container_ratio: $(this).width() / $(this).height()
  lines: elem.height() / line_height
  ratios_by_line: {}
  if !ratios_by_line[lines]
    ratios_by_line[lines]: {'width': elem.width(), 'height': elem.height(), 'container_ratio': container_ratio, 'ratio': (elem.width() / elem.height()), 'ratio_difference': (container_ratio / (elem.width() / elem.height()))}

  console.log elem.height() + " / " + line_height + " = " + (elem.height() / line_height)

  width: 0.5
  while elem.height() / line_height > 1
    console.log elem.height() + " / " + line_height + " = " + (elem.height() / line_height)
    elem.css {'width': (width: width + 0.5) + 'em'}
    lines: elem.height() / line_height
    if !ratios_by_line[lines]
      ratios_by_line[lines]: {'width': elem.width(), 'height': elem.height(), 'container_ratio': container_ratio, 'ratio': (elem.width() / elem.height()), 'ratio_difference': (container_ratio / (elem.width() / elem.height()))}

  console.log "done: " + elem.height() + " / " + line_height + " = " + (elem.height() / line_height)
  console.log ratios_by_line

  closest_ratio_to_one: 1
  best_entry: null
  $.each ratios_by_line, (lines, data) ->
    console.log "on " + lines + ": " + data
    if Math.abs(data.ratio_difference - 1) < closest_ratio_to_one
      closest_ratio_to_one: Math.abs(data.ratio_difference - 1)
      best_entry: lines

  console.log "best: " + closest_ratio_to_one + ", on " + best_entry + " lines"

  # elem.css {'width': ratios_by_line[best_entry].width + 'px'}
  scaling_factor: if ratios_by_line[best_entry].ratio_difference > 1
    console.log "height-limited scaling_factor: " + elem.css('font-size') + " * (" + $(this).height() + "/" + ratios_by_line[best_entry].height + ")"
    console.log "height-limited scaling_factor: " + scaling_factor
    $(this).height() / ratios_by_line[best_entry].height
  else
    console.log "width-limited scaling_factor: " + elem.css('font-size') + " * (" + $(this).height() + "/" + ratios_by_line[best_entry].height + ")"
    console.log "width-limited scaling_factor: " + scaling_factor
    $(this).width() / ratios_by_line[best_entry].width

  console.log "font-size: " + elem.css('font-size') + " * (" + $(this).height() + "/" + elem.height() + ")"

  elem.css {
    'font-size': (parseInt(elem.css('font-size')) * scaling_factor) + 'px'
    'width': 'auto'
  }
  elem.css {
    'margin-top': (($(this).height() - (ratios_by_line[best_entry].height * scaling_factor)) / 2) + 'px'
  }


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
