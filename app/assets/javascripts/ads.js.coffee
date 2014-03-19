# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  if $("body").data("namespace") == null and $("body").data("controller") == "ads" and ($("body").data("action") == "new" or $("body").data("action") == "edit" or $("body").data("action") == "create")
    show_dynamic_fields = ->
      $('.field.dynamic').hide()
      code = $("#ad_code").val()
      switch code
        when "DA" then $("#ad_event_id").parent().show()
        when "DG" then $("#ad_service_id").parent().show()
        when "H", "H2", "C", "C2", "DC", "S", "S2", "DS" then $("#ad_section_id").parent().show()
    show_dynamic_fields()
    $("#ad_code").on "change", (event) ->
      show_dynamic_fields()