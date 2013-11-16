$(document).ready ->
  $(".open").on "click", (event) ->
    event.preventDefault()
    $(@).parent().find("nav").toggle()
