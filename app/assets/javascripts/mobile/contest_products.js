$(document).ready(function() {
  if ($('.game_share_content').length > 0) {
    window._bd_share_config = {
      common: {
        bdText: '我们参加了青年创业创新大赛，来围观吧~',
        bdDesc: '我们参加了青年创业创新大赛，来围观吧~',
        bdPic: $('.game_poster')[0].src
      },
      share: [{
        "bdSize": 24
      }]
    }
    with(document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?cdnversion=' + ~(-new Date() / 36e5)];
  }
});