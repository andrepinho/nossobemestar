hideNewsletterBait = false
$(document).ready ->
  $(".open").on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    $(@).parent().find("nav").toggle()
  $("input").click (event) ->
    event.stopPropagation()
  setTimeout (->
    $('#flash').slideDown('slow')
  ), 100
  setTimeout (->
    $('#flash').slideUp('slow')
  ), 16000
  $(window).on "click", ->
    $('#flash').slideUp('slow')
    $('.open').parent().find("nav").hide()
  $(window).on "scroll", ->
    scrollPercent = ($(window).scrollTop() / ($(document).height()-$(window).height())) * 100
    if scrollPercent > 40 && scrollPercent < 92 && hideNewsletterBait == false
      $('#newsletter_bait_wrapper').show()
    else
      $('#newsletter_bait_wrapper').hide()
  $("#newsletter_bait_wrapper .close").on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    hideNewsletterBait = true
    $('#newsletter_bait_wrapper').hide()
