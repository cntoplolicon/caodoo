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