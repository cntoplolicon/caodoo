// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {

  var initSecurityCodeButton = function (button, url) {
    $(button).click(function (event) {
      event.preventDefault();
      var username = $('#username-input').val();
      var xhr = $.post(url, {username: username, authenticity_token: $('meta[name=csrf-token]').attr('content')})
        .fail(function () {
          var response = $.parseJSON(xhr.responseText);
          $('#username-error').text(response.error);
        })
        .done(function () {
          var time = 60;
          $('#username-error').text('');
          $('.security-code-button').prop('disabled', true);
          $('.security-code-button').css('color', 'grey');
          $('.security-code-button').text(time + 's重新发送');
          var timecounter = window.setInterval(function () {
            if (time-- > 0) {
              $('.security-code-button').text(time + 's重新发送');
            } else {
              myStopFunction();
            }
          }, 1000);

          function myStopFunction() {
            window.clearInterval(timecounter);
            $('.security-code-button').prop('disabled', false);
            $('.security-code-button').text('重新发送');
            $('.security-code-button').css('color', '');
          }
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

  $('.user_info_box .cancel_button').click(function () {
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

  //new user validate

  $("#new-user").submit(function () {

    var b = true;
    if (!$("#username-input").val().match(validate_regex.username)) {
      $("#username-error").text(validate_message.username.invalid);
      b = false;
    } else {
      $("#username-error").text("");
    }

    if (!$("#user_security_code").val().match(validate_regex.captch)) {
      $("#security-code-error").text(validate_message.captcha.invalid);
      b = false;
    } else {
      $("#security-code-error").text("");

    }

    if (!$("#user_password").val().match(validate_regex.password)) {
      $("#userpwd-error").text(validate_message.password.invalid);
      b = false;
    } else {
      $("#userpwd-error").text("");
    }
    return b;

  });

  //login user validate

  $("#login-user").submit(function () {

    var b = true;
    if (!$("#user_username").val().match(validate_regex.username)) {
      $("#username-error").text(validate_message.username.invalid);
      b = false;
    } else {
      $("#username-error").text("");
    }

    if (!$("#user_password").val().match(validate_regex.password)) {
      $("#userpwd-error").text(validate_message.password.invalid);
      b = false;
    } else {
      $("#userpwd-error").text("");
    }

    return b;

  });

  //forget pwd validate

  $("#forget-password").submit(function () {
    var b = true;
    if (!$("#username-input").val().match(validate_regex.username)) {
      $("#username-error").text(validate_message.username.invalid);
      b = false;
    } else {
      $("#username-error").text("");
    }

    if (!$("#user_security_code").val().match(validate_regex.captch)) {
      $("#security-code-error").text(validate_message.captcha.invalid);
      b = false;
    } else {
      $("#security-code-error").text("");
    }
    return b;

  });

  //update phone validate

  $("#update-phone").submit(function () {
    var b = true;
    if (!$("#username-input").val().match(validate_regex.username)) {
      $("#username-error").text(validate_message.username.invalid);
      b = false;
    } else {
      $("#username-error").text("");
    }

    if (!$("#user_security_code").val().match(validate_regex.captch)) {
      $("#security-code-error").text(validate_message.captcha.invalid);
      b = false;
    } else {
      $("#security-code-error").text("");
    }
    return b;

  });

  //update pwd validate

  $("#update-pwd").submit(function () {
    var b = true;
    if (!$("#user_old_password").val().match(validate_regex.captch)) {
      $("#user_old_password-error").text(validate_message.password.invalid);
      b = false;
    } else {
      $("#user_old_password-error").text("");
    }

    if (!$("#user_password").val().match(validate_regex.password)) {
      $("#user_new_password-error").text(validate_message.password.invalid);
      b = false;
    } else {
      $("#user_new_password-error").text("");
    }

    if (!$("#user_password_confirmation").val().match(validate_regex.password)) {
      $("#user_new_password2-error").text(validate_message.password.invalid);
      b = false;
    } else {
      $("#user_new_password2-error").text("");
    }

    // compare
    if (!($("#user_password_confirmation").val() == $("#user_password").val())) {
      $("#user_new_password2-error").text(validate_message.password.password_confirmation.confirmation);
      b = false;
    } else {
      $("#user_new_password2-error").text("");
    }
    return b;
  });

})

