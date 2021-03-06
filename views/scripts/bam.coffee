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

  # console.log elem.height() + " / " + line_height + " = " + (elem.height() / line_height)

  width: 0.5
  while elem.height() / line_height > 1
    # console.log elem.height() + " / " + line_height + " = " + (elem.height() / line_height)
    elem.css {'width': (width: width + 0.5) + 'em'}
    lines: elem.height() / line_height
    if !ratios_by_line[lines]
      ratios_by_line[lines]: {'width': elem.width(), 'height': elem.height(), 'container_ratio': container_ratio, 'ratio': (elem.width() / elem.height()), 'ratio_difference': (container_ratio / (elem.width() / elem.height()))}

  # console.log "done: " + elem.height() + " / " + line_height + " = " + (elem.height() / line_height)
  # console.log ratios_by_line

  closest_ratio_to_one: null
  best_entry: null
  $.each ratios_by_line, (lines, data) ->
    if closest_ratio_to_one == null || Math.abs(data.ratio_difference - 1) < closest_ratio_to_one
      closest_ratio_to_one: Math.abs(data.ratio_difference - 1)
      best_entry: lines

  # console.log "best: " + closest_ratio_to_one + ", on " + best_entry + " lines"

  # elem.css {'width': ratios_by_line[best_entry].width + 'px'}
  scaling_factor: if ratios_by_line[best_entry].ratio_difference > 1
    # console.log "height-limited scaling_factor: " + elem.css('font-size') + " * (" + $(this).height() + "/" + ratios_by_line[best_entry].height + ")"
    $(this).height() / ratios_by_line[best_entry].height
  else
    # console.log "width-limited scaling_factor: " + elem.css('font-size') + " * (" + $(this).height() + "/" + ratios_by_line[best_entry].height + ")"
    $(this).width() / ratios_by_line[best_entry].width

  # console.log "scaling_factor: " + scaling_factor
  # console.log "font-size: " + elem.css('font-size') + " * (" + $(this).height() + "/" + elem.height() + ")"

  elem.css {
    'font-size': (parseInt(elem.css('font-size')) * scaling_factor) + 'px'
    'width': 'auto'
  }
  elem.css {
    'margin-top': (($(this).height() - elem.height()) / 2) + 'px'
  }

$.fn.set_styles: (style) ->
  if style == 'basic'
    $(this).css({'color': '#fff', 'background-color': '#000'})
  else if style == 'heart'
    $(this).css({'color': '#000', 'background-color': '#fff'})
  else if style == 'jprdy'
    $(this).css({'color': '#fff', 'background-color': '#00c'})

$.fn.randomizeColour: ->
  randomColor: -> Math.floor Math.random() * 256
  $(this).css({'background-color': 'rgb(' + randomColor() + ',' + randomColor() + ',' + randomColor() + ')'})
  if $(this).css('color') == 'rgb(255, 255, 255)'
    $(this).css({'color': '#000'}) if Math.random() > 0.5
    Cufon.replace('div#bigarsemessage.magic div', { fontFamily: 'FuturaCondensedExtraBoldOblique', fontStretch: 'condensed', color: '#000' }) if Cufon?
  else if $(this).css('color') == 'rgb(0, 0, 0)'
    $(this).css({'color': '#fff'}) if Math.random() > 0.5
    Cufon.replace('div#bigarsemessage.magic div', { fontFamily: 'FuturaCondensedExtraBoldOblique', fontStretch: 'condensed', color: '#fff' }) if Cufon?
  $(this).data 'timeout', setTimeout((-> $('#bigarsemessage').randomizeColour()), 20)

$.fn.attach_events: (style) ->
  if style == 'magic'
    $(this).randomizeColour()

$.fn.bigarsemessage: (text) ->
  text: "Big Arse Message" if text.length == 0
  $(this).children('div').html(text)
  $(this).attr 'class', $('input#style')[0].value
  $(this).show()
  $(this).typeset()
  $(this).set_styles $(this).attr('class')
  $(this).attach_events $(this).attr('class')
  # console.log "Got Cufon - "+$(this).attr('class') if Cufon?
  Cufon.refresh('div#bigarsemessage.'+$(this).attr('class')+' div') if Cufon?

$ ->
  $('#bigarsemessage').hide().click ->
    clearTimeout $(this).data('timeout') if $(this).data('timeout')
    $(this).hide()
  $('form li input[type=submit]').click -> false
  
  $('.type_select a').click ->
    $('.type_select a').removeClass('selected')
    $('input#style')[0].value=this.className
    $(this).addClass("selected")
    return false

  $('form li input[type=submit][name=Preview]').click ->
    $('#bigarsemessage').bigarsemessage($('textarea.message').val())
  $('form li input[type=submit][name=Save]').click ->
    $.ajax({
      type: "POST",
      url: "/save",
      data: "message="+$("textarea.message")[0].value+"&type="+$("input#style")[0].value,
      success: (save_hash) ->
        $("input#url")[0].value: 'bigarsemessage.com/'+save_hash
    });

  if $('ul.type_select a.selected').length == 0
    $('ul.type_select a.basic').click()

  $('textarea.message').keyup ->
    if $(this).val().length > MessageLength
      $(this).val($(this).val().substring(0,MessageLength))
  
  $("input#url").click ->
    $(this).select()
  
  for font in ['/fonts/AmericanTypewriter.ttf', '/fonts/Korinna-Bold.ttf']
    new_font: new Image()
    new_font.src: font