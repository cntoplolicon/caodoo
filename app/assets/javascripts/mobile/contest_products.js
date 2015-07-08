$(document).ready(function() {
	console.log("1");
  if ($('.game_share_content').length > 0) {
    window._bd_share_config = {
      common: {
        bdText: '我们参加了青年创业创新大赛，向你推荐' + $('.product-detail-text-head').text() + ', 来看看吧~',
        bdDesc: '我们参加了青年创业创新大赛，向你推荐' + $('.product-detail-text-head').text() + ', 来看看吧~',
        bdPic: $('.game_recommend_product_img')[0].src
      },
      share: [{
        "bdSize": 24
      }]
    }
    with(document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?cdnversion=' + ~(-new Date() / 36e5)];
  }
});
