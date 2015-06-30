// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {
  var initSecurityCodeButton = function(button, url) {
    $(button).click(function (event) {
      event.preventDefault();
      var username = $('#username-input').val();
      var xhr = $.post(url, {username: username, authenticity_token: $('meta[name=csrf-token]').attr('content')})
      .fail(function() {
        var response = JSON.parse(xhr.responseText);
        $('#username-error').text(response.error);
      })
      .done(function() {
        $('#username-error').text('');
      });
    });
  };

  $('.update_username_action').click(function () {
    $('.username-box').show();
    $('.password-box').hide();
  });
  $('.update_password_action').click(function () {
    $('.username-box').hide();
    $('.password-box').show();
  });
  if ($('#page-status').val() === 'editing_username') {
    $('.username-box').show();
  } else if ($('#page-status').val() === 'editing_password') {
    $('.password-box').show();
  }

  $('.user_info_box .cancel_button').click(function() {
    $(this).closest('.user_info_box').hide();
  });

  if ($('.reset-password-to-login-link').attr('href')) {
    window.setTimeout(function () {
      window.location.href = $('.reset-password-to-login-link').attr('href');
    }, 2000);
  }

  initSecurityCodeButton('.register-box .security-code-button', '/users/get_security_code_for_new_user');
  initSecurityCodeButton('.forget-password-box .security-code-button', '/users/get_security_code_for_password');
  initSecurityCodeButton('.username-box .security-code-button', '/users/get_security_code_for_new_user');
})

