/**
 * Created by silentgod on 15-7-2.
 */

$(document).ready(function() {
  var adapt_height = Math.max($(window).height(), $('.detail_container').height() + 64);
  $('input, textarea').placeholder();
  $('.block_container_menu').css('height', adapt_height - 24);
  $(".game_header_team_name").click(function(){
    var team_menu = $("#game_header_management_menu");
    if (team_menu.css("display") === "none") {
      team_menu.show();
    } else {
      team_menu.hide();
    }
  });
});
$(window).resize(function() {
  var resize_height = Math.max($(window).height(), $('.detail_container').height() + 64);
  $('.block_container_menu').css('height', resize_height -24);
});