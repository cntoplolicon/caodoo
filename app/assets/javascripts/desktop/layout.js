$(document).ready(function () {
  $('.header_account_link').click(function() {
    $('.cd_dropdown').toggle();
  });
  $('input, textarea').placeholder();
  $('#open_privicy_box').click(function() {
    $('#terms_of_privicy_container').show();
  });
  $('.terms_of_privicy_close_button').click(function() {
    $('#terms_of_privicy_container').hide();
  });
});
function showRemainTime(time) {
  if (typeof(time) !== 'number') {
    return '';
  }
  var _minute = 60;
  var _hour = _minute * 60;
  var hours = Math.floor(time / _hour);
  var minutes = Math.floor((time % _hour) / _minute);
  var seconds = Math.floor((time % _minute));
  if (hours < 10) {
    hours = '0' + hours;
  }
  if (minutes < 10) {
    minutes = '0' + minutes;
  }
  if (seconds < 10) {
    seconds = '0' + seconds;
  }
  return hours + ':' + minutes + ':' + seconds;
}
