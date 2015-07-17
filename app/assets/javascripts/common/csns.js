(function($) {
  var platforms = {
    'tsina': 'http://service.weibo.com/share/share.php?title={{title}}&url={{url}}&pic={{pic}}',
    'qzone': 'http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?title={{title}}&desc={{desc}}&url={{url}}&pics={{pic}}',
    'renren': 'http://widget.renren.com/dialog/share?resourceUrl={{url}}&title={{title}}&description={{desc}}&pic={{pic}}'
  };
  $.fn.csns = function(options) {
    var settings = $.extend({
      url: window.location.href,
      title: document.title,
      desc: document.title,
      pic: $('img').prop('src'),
      qrcode: {
        render: 'div',
        size: 185,
        ecLevel: 'H',
        minVersion: 5
      }
    }, options);
    settings.qrcode = $.extend({
      text: settings.url
    }, settings.qrcode);
    var wechatDialog;
    if (this.find('.csns-share-button[data-cmd="wechat"]').length > 0) {
      var wechatDialog = $('<div class="csns-wechat-dialog"><div class="csns-wechat-dialog-header"><span>分享到微信朋友圈</span><a href="#" class="">×</a></div><div class="csns-wechat-dialog-qrcode"></div><div class="csns-wechat-dialog-footer">打开微信，点击底部的“发现“<br>使用“扫一扫”即可将网页分享至朋友圈</div></div>');
      wechatDialog.find('.csns-wechat-dialog-qrcode').qrcode(settings.qrcode);
      $('body').append(wechatDialog);
      wechatDialog.find('.csns-wechat-dialog-header a').click(function(event) {
        event.preventDefault();
        wechatDialog.hide();
      });
    }
    this.find('.csns-share-button').click(function(event) {
      event.preventDefault();
      var command = $(this).data('cmd');
      if (command === 'wechat') {
        wechatDialog.css('top', ($(window).height() - wechatDialog.height()) / 2 + $(window).scrollTop());
        wechatDialog.css('left', ($(window).width() - wechatDialog.width()) / 2 + $(window).scrollLeft());
        wechatDialog.show();
      } else {
        var platformUrl = platforms[command];
        if (platformUrl !== undefined) {
          for (var key in settings) {
            platformUrl = platformUrl.replace('{{' + key + '}}', encodeURIComponent(settings[key]));
          }
        }
        window.open(platformUrl);
      }
    });
  }
})(window.jQuery || window.Zepto);
