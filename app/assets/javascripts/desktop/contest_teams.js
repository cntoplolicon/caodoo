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

$(document).ready(function(){
  $(".team_performance_tab a").click(function(){
    $(".team_performance_tab a").removeAttr("class");
    $(this).attr("class", "current_tab");
    if ($(this).attr("id") === "team_performance_data_total") {
      $("#team_performance_top_results_total").show();
      $("#team_performance_top_results_today").hide();
    } else {
      $("#team_performance_top_results_total").hide();
      $("#team_performance_top_results_today").show();
    }
  });
  $(".team_performance_bottom_tab a").click(function(){
    $(".team_performance_bottom_tab a").removeAttr("class");
    $(this).attr("class", "current_tab");
    if ($(this).attr("id") === "team_performance_amounts_total") {
      $("#team_performance_bottom_table_total").show();
      $("#team_performance_bottom_table_today").hide();
    } else {
      $("#team_performance_bottom_table_total").hide();
      $("#team_performance_bottom_table_today").show();
    }
  });
});