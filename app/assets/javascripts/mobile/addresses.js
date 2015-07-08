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
    $('#set_default_address_box').data('addressId', $(this).data('addressId'));
    $('#set_default_address_box').show();
  });

  $('.cancel_update_default_address_button').click(function() {
    $('#set_default_address_box').hide();
  });
  $('.confirm_update_default_address_button').click(function() {
    var address_id = $('#set_default_address_box').data('addressId');
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
    var form = $(this).closest('form');
    $.ajax({
      url: form.attr('action'),
      data: form.serializeArray(),
      type: 'POST',
      complete: function(xhr) {
        if(xhr.status == 400) {
          $('#edit_address_box').html(xhr.responseText);
          edit_address_box_ready();
        }
        if(xhr.status == 302) {
          window.location.reload();
        }
        if(xhr.status == 200) {
          window.location.reload();
        }
      }
    });
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
