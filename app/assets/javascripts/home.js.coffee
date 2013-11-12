# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  unless $("body").data("coordinates") or $("body").data("region")
    console.log "foi!"
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        window.location.href="#{window.location.href}?latitude=#{position.coords.latitude}&longitude=#{position.coords.longitude}"
