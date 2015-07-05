// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $('.refund_record_new_action, .refund_record_edit_action').click(function(event) {
    event.preventDefault();
    $('#team_return_goods_popup').load($(this).attr('href'), function() {
      $('#team_return_goods_popup').show();
    });
  });

  $('#team_return_goods_popup').on('click', '.return_good_reset', function() {
      $('#team_return_goods_popup').hide();
  });
  $('#team_return_goods_popup').on('click', '.return_good_submit', function(event) {
    event.preventDefault();
    var form = $(this).closest('form');
    $.ajax({
      url: form.attr('action'),
      data: form.serializeArray(),
      type: 'POST',
      statusCode: {
        400: function(xhr) {
          $('#team_return_goods_popup').html(xhr.responseText);
        },
        302: function() {
          window.location.reload();
        },
        200: function() {
          window.location.reload();
        }
      }
    });
  });

});
