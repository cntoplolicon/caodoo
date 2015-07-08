// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {

  function validate_address() {
    var b = true;
    if ($("#address_receiver").val() == "") {
      $("#address-receiver-error").text(validate_message.address.receiver.blank);
      b = false;
    } else {
      $("#address-receiver-error").text("");
    }
    if ($("#address_phone").val() == "") {
      $("#address-phone-error").text(validate_message.phone.invalid);
      b = false;
    } else {
      $("#address-phone-error").text("");
    }

    if ($("#province_select").val() == "") {
      $("#address-area-error").text(validate_message.province_code.blank);
      b = false;
    } else {
      $("#address-area-error").text("");
    }
    if ($("#address_detailed_address").val() == "") {
      $("#address-detail-error").text(validate_message.detailed_address.blank);
      b = false;
    } else {
      $("#address-detail-error").text("");
    }
    return b;

  }

  //add user address validate

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

  var toggle_region_selection = function() {
    $(this).prop('disabled', $(this).find('option').length <= 1);
  }
  var edit_address_box_ready = function() {
    $('#edit_address_box').show();
    toggle_region_selection.call($('#city_select'));
    toggle_region_selection.call($('#district_select'));
  }

  $('.new_address_action').click(function() {
    $('#edit_address_box').load($('.new_address_url').val(), edit_address_box_ready);
  });
  $('.edit_address_action').click(function() {
    $('#edit_address_box').load($(this).closest('.user_address_li').find('.edit_address_url').val(), edit_address_box_ready);
  });
  $('#edit_address_box').on('click', '.cancel_edit_address_button', function() {
    $('#edit_address_box').hide();
  });
  $('#edit_address_box').on('click', '.save_address_button', function() {

    if (validate_address()) {

      var form = $(this).closest('form');
      $.ajax({
        url: form.attr('action'),
        data: form.serializeArray(),
        type: 'POST',
        statusCode: {
          400: function(xhr) {
            $('#edit_address_box').html(xhr.responseText);
            edit_address_box_ready();
          },
          302: function() {
            window.location.reload();
          },
          200: function() {
            window.location.reload();
          }
        }
      });

    }
  });

  $('#edit_address_box').on('change', '#province_select', function() {
    $('#city_select').find('option').remove();
    $('#district_select').find('option').remove();
    if ($(this).val() !== '') {
      $('#city_select').load('/provinces/' + $(this).val() + '/cities', toggle_region_selection);
    }
  });
  $('#edit_address_box').on('change', '#city_select', function() {
    $('#district_select').find('option').remove();
    if ($(this).val() !== '') {
      $('#district_select').load('/cities/' + $(this).val() + '/districts', toggle_region_selection);
    }
  });

});


