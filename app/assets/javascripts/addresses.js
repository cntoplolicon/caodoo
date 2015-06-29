// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {
  $('.delete_address_action').click(function() {
    $('#delete_address_box').data('addressId', $(this).data('addressId'));
    $('#delete_address_box').show();
  });
  $('.cancel_delete_address_button').click(function() {
    $('#delete_address_box').hide();
  });
  $('.confirm_delete_address_button').click(function() {
    var address_id = $('#delete_address_box').data('addressId');
    $('.delete_address_' + address_id + '_form').submit();
  });

  $('.update_default_address_action').click(function() {
    $('#update_default_address_box').data('addressId', $(this).data('addressId'));
    $('#update_default_address_box').show();
  });

  $('.cancel_update_default_address_button').click(function() {
    $('#update_default_address_box').hide();
  });
  $('.confirm_update_default_address_button').click(function() {
    var address_id = $('#update_default_address_box').data('addressId');
    $('.update_default_address_' + address_id + '_form').submit();
  });
});
