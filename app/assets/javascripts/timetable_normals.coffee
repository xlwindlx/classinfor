# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener 'turbolinks:load', ->

  check_it = (field_obj) ->
    $fieldtext = $('#' + field_obj.id + 'text')
    $field = $('#' + field_obj.id)
    $fieldtext.prop 'disabled', if $field.is(':checked') == true then false else true
    if $field.is(':checked') == false
      $fieldtext.val("")
    return

  $("#div, #subject, #grade, #title, #grades, #prof, #proffesion, #day, #time, #classroom").click ->
    check_it(this)

  return