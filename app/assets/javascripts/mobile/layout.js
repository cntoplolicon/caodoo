$(document).ready(function () {
  $('.mobile_go_back_button').click(function() {
    window.history.back();
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
  	result += days + '天 ';
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
  return result + hours + '小时 ' + minutes + ':' + seconds ;
}