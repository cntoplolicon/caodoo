// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
    $(".about_segment_img_normal").hover(function(){
      $(this).hide();
      $(this).next().show();
    });
    $(".about_segment_img").mouseout(function(){
      $(this).hide();
      $(this).prev().show();
    });
  });

