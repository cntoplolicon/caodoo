$(document).ready(function () {
  $('.mobile_go_back_button').click(function() {
    window.history.back();
  });
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
  var _day = _hour * 24;
  var result = '';
  var days = Math.floor(time / _day)
  var hours = Math.floor((time % _day) / _hour);
  var minutes = Math.floor((time % _hour) / _minute);
  var seconds = Math.floor((time % _minute));
  if(days > 0 ) {
    result += days + '天';
  }
  if (hours < 10) {
    hours = '0' + hours;
  }
  if (minutes < 10) {
    minutes = '0' + minutes;
  }
  if (seconds < 10) {
    seconds = '0' + seconds;
  }
  return result + hours + '时' + minutes + '分' + seconds + '秒' ;
}