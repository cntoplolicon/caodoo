// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {
  $('.register-box .security-code-button').click(function (event) {
    event.preventDefault();
    var username = $('#username-input').val();
    var xhr = $.post('/users/get_security_code_for_new_user', 
                     {username: username, authenticity_token: $('meta[name=csrf-token]').attr('content')})
    .fail(function() {
      var response = JSON.parse(xhr.responseText);
      $('#username-error').text(response.error);
    })
    .done(function() {
      $('#username-error').text('');
    });
  });
})

