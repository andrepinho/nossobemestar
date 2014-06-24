# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  if $("body").data("controller") == "posts" and $("body").data("action") == "show" and $("body").data("namespace") == null
    $(".icon-thumbs-up").on "click", (event) ->
      event.preventDefault()
      event.stopPropagation()
      $.get $(@).attr("href"), ->
        container = $(event.target).closest(".likes")
        container.find(".thumbs").hide()
        container.find("h4").html('<strong>Obrigado por seu voto!</strong><br />Compartilhe este conteúdo').after('<div class="icon-arrow-down-right"></div>')
    $(".icon-thumbs-down").on "click", (event) ->
      event.preventDefault()
      event.stopPropagation()
      $.get $(@).attr("href"), ->
        container = $(event.target).closest(".likes")
        container.find(".thumbs").hide()
        container.find("h4").text('Obrigado por seu voto!')