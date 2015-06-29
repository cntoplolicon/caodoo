// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $('.return_application_action').click(function() {
    $('#return_application_box').show();
  });
  $('.close_return_application_box_button').click(function() {
    $('#return_application_box').hide();
  });
  $('.cancel_order_action').click(function() {
    $('#cancel_order_box').data('orderId', $(this).data('orderId'));
    $('#cancel_order_box').show();
  });
  $('.cancel_cancel_order_button').click(function() {
    $('#cancel_order_box').hide();
  });
});
