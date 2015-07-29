// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var paymentTimeCountDown = function() {
    if (time > 0) {
      time = Math.max(time - 1, 0);
      var remainTimeString = orderRemainTime(time);
      $('#payment-remain-time-hidden-field').val(time);
      $('.payment-remain-time').text(remainTimeString);
    } else if (time === 0) {
      time--;
      window.location.reload();
    }
  };

  function orderRemainTime(time) {
    if (typeof(time) !== 'number') {
      return '00分00秒';
    }
    var _minute = 60;
    var minutes = Math.floor(time / _minute);
    var seconds = Math.floor(time % _minute);
    if (minutes < 10) {
      minutes = '0' + minutes;
    }
    if (seconds < 10) {
      seconds = '0' + seconds;
    }
    return minutes + '分' + seconds + '秒';
  };
  $('input[name = "order_radio"]').change(function() {
    $('#payment-before-choose').hide();
    $('.payment-button').show();
  });

  if ($('.wechat-radio').prop('checked') || $('.alipay-radio').prop('checked')) {
    $('#payment-before-choose').hide();
    $('.payment-button').show();
  }
  if ($('.payment-deadline').length > 0) {
    var time = $('#payment-remain-time-hidden-field').val();
    paymentTimeCountDown();
    window.setInterval(paymentTimeCountDown, 1000);
  }
  ;
  var wxPayUrl = $('#wechat-qrcode-field').val();
  $('.qrcode').qrcode({
    'render': 'div',
    'size': 250,
    'text': wxPayUrl
  });
  $('.return_application_action').click(function() {
    $('#return_application_box').show();
  });
  $('.close_return_application_box_button').click(function() {
    $('#return_application_box').hide();
  });
  $('.cancel_order_action').click(function() {
    $('#cancel_order_box').data('orderId', $(this).data('orderId'));
    $('#cancel_order_box').show();
  });
  $('.cancel_cancel_order_button').click(function() {
    $('#cancel_order_box').hide();
  });
  $('.confirm_cancel_order_button').click(function() {
    var orderId = $('#cancel_order_box').data('orderId');
    $('.confirm_cancel_order_button').prop('disabled', true);
    $('.cancel_order_' + orderId + '_form').submit();
  });
  $('.receive_order_action').click(function() {
    $('#receive_order_box').data('orderId', $(this).data('orderId'));
    $('#receive_order_box').show();
  });
  $('.cancel_receive_order_button').click(function() {
    $('#receive_order_box').hide();
  });
  $('.confirm_receive_order_button').click(function() {
    var orderId = $('#receive_order_box').data('orderId');
    $('.confirm_receive_order_button').prop('disabled', true);
    $('.receive_order_' + orderId + '_form').submit();
  });
  $('.payment-button').click(function() {
    if ($('.alipay-radio').prop('checked')) {
      $('#alipay_confirm_box').show();
      $('.alipay_submission_form').submit();
    } else if ($('.wechat-radio').prop('checked')) {
      $('.wechat_submission_form').submit();
    }
  });
  $('#alipay_confirm_box .alipay_fail_button').click(function() {
    $('#alipay_confirm_box').hide();
    $('#payment_failure_box').show();
  });
  $('#payment_failure_box .close_button').click(function() {
    $('#payment_failure_box').hide();
  });
  if ($('#order_status_url').length > 0) {
    window.setInterval(function() {
      $.ajax({
        url: $('#order_status_url').val(),
        type: 'GET',
        dataType: 'json',
        success: function(res) {
          if (res.status === 1) {
            window.location.href = $('#payment_succeed_url').val();
          }
        }
      });
    }, 7000);
  }
  $('.order-express-info-link').click(function(event) {
    event.preventDefault();
    $(this).parent().hide();
    var detailPanel = $('.order-express-information-detail');
    detailPanel.show();
    detailPanel.load($(this).prop('href'));
  });
});
