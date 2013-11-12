$(document).ready ->
  $("#current_region .open").on "click", (e) ->
    e.preventDefault()
    $("#current_region nav").toggle()

