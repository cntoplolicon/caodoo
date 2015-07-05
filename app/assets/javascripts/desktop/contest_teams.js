// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var adapt_height = Math.max($(window).height(), $('.detail_container').height() + 64);
  $('.block_container_menu').css('height', adapt_height - 24);
  $(".game-header-setting").click(function(){
    $("#game_header_management_menu").toggle();
  });
  $(window).resize(function() {
    var resize_height = Math.max($(window).height(), $('.detail_container').height() + 64);
    $('.block_container_menu').css('height', resize_height -24);
  });
});

